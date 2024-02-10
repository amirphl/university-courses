/*
 * Copyright 2019 Maksim Zheravin
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package exchange.core2.tests.util;

import com.google.common.collect.Iterables;
import exchange.core2.core.common.*;
import exchange.core2.core.common.api.*;
import exchange.core2.core.common.cmd.CommandResultCode;
import exchange.core2.core.common.cmd.OrderCommand;
import exchange.core2.core.common.cmd.OrderCommandType;
import exchange.core2.core.common.config.LoggingConfiguration;
import exchange.core2.core.orderbook.IOrderBook;
import exchange.core2.core.orderbook.OrderBookNaiveImpl;
import lombok.Builder;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.math3.distribution.ParetoDistribution;
import org.apache.commons.math3.distribution.RealDistribution;
import org.apache.commons.math3.random.JDKRandomGenerator;
import org.eclipse.collections.impl.map.mutable.primitive.IntIntHashMap;
import org.jetbrains.annotations.NotNull;

import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.atomic.LongAdder;
import java.util.function.LongConsumer;
import java.util.function.UnaryOperator;
import java.util.stream.Collectors;
import java.util.stream.DoubleStream;

import static exchange.core2.tests.util.TestConstants.SYMBOLSPEC_EUR_USD;

@Slf4j
public final class TestOrdersGenerator {


    public static final double CENTRAL_MOVE_ALPHA = 0.01;

    public static final int CHECK_ORDERBOOK_STAT_EVERY_NTH_COMMAND = 512;

    public static final UnaryOperator<Integer> UID_PLAIN_MAPPER = i -> i + 1;

    // TODO allow limiting max volume
    // TODO allow limiting number of opened positions (currently it just grows)
    // TODO use longs for prices (optionally)

    public static MultiSymbolGenResult generateMultipleSymbols(final TestOrdersGeneratorConfig config) {

        final List<CoreSymbolSpecification> coreSymbolSpecifications = config.coreSymbolSpecifications;
        final int totalTransactionsNumber = config.totalTransactionsNumber;
        final List<BitSet> usersAccounts = config.usersAccounts;
        final int targetOrderBookOrdersTotal = config.targetOrderBookOrdersTotal;
        final int seed = config.seed;

        final Map<Integer, GenResult> genResults = new HashMap<>();

        try (ExecutionTime ignore = new ExecutionTime(t -> log.debug("All test commands generated in {}", t))) {

            final double[] distribution = createWeightedDistribution(coreSymbolSpecifications.size(), seed);
            int quotaLeft = totalTransactionsNumber;
            final Map<Integer, CompletableFuture<GenResult>> futures = new HashMap<>();

            final LongConsumer sharedProgressLogger = createAsyncProgressLogger(totalTransactionsNumber + targetOrderBookOrdersTotal);

            for (int i = coreSymbolSpecifications.size() - 1; i >= 0; i--) {
                final CoreSymbolSpecification spec = coreSymbolSpecifications.get(i);
                final int orderBookSizeTarget = (int) (targetOrderBookOrdersTotal * distribution[i] + 0.5);
                final int commandsNum = (i != 0) ? (int) (totalTransactionsNumber * distribution[i] + 0.5) : Math.max(quotaLeft, 1);
                quotaLeft -= commandsNum;
//                log.debug("{}. Generating symbol {} : commands={} orderBookSizeTarget={} (quotaLeft={})", i, spec.symbolId, commandsNum, orderBookSizeTarget, quotaLeft);
                futures.put(spec.symbolId, CompletableFuture.supplyAsync(() -> {
                    final int[] uidsAvailableForSymbol = UserCurrencyAccountsGenerator.createUserListForSymbol(usersAccounts, spec, commandsNum);
                    final int numUsers = uidsAvailableForSymbol.length;
                    final UnaryOperator<Integer> uidMapper = idx -> uidsAvailableForSymbol[idx];
                    return generateCommands(commandsNum, orderBookSizeTarget, numUsers, uidMapper, spec.symbolId, false, config.avalancheIOC, sharedProgressLogger, seed);
                }));
            }

            futures.forEach((symbol, future) -> {
                try {
                    genResults.put(symbol, future.get());
                } catch (InterruptedException | ExecutionException ex) {
                    throw new IllegalStateException("Exception while generating commands for symbol " + symbol, ex);
                }
            });
        }


        final int benchmarkCmdSize = genResults.values().stream().mapToInt(genResult -> genResult.commandsBenchmark.size()).sum();

        final CompletableFuture<List<ApiCommand>> apiCommandsFill = mergeCommands(genResults, config.seed, false, CompletableFuture.completedFuture(null));
        final CompletableFuture<List<ApiCommand>> apiCommandsBenchmark = mergeCommands(genResults, config.seed, true, apiCommandsFill);

        return MultiSymbolGenResult.builder()
                .genResults(genResults)
                .apiCommandsFill(apiCommandsFill)
                .apiCommandsBenchmark(apiCommandsBenchmark)
                .benchmarkCommandsSize(benchmarkCmdSize)
                .build();
    }

    private static CompletableFuture<List<ApiCommand>> mergeCommands(
            Map<Integer, GenResult> genResults,
            long seed,
            boolean takeBenchmark,
            CompletableFuture<?> runAfterThis) {

        final List<List<OrderCommand>> commandsLists = genResults.values().stream()
                .map(genResult -> takeBenchmark ? genResult.commandsBenchmark : genResult.commandsFill)
                .collect(Collectors.toList());

        log.debug("Merging {} commands for {} symbols ({})...",
                commandsLists.stream().mapToInt(Collection::size).sum(), genResults.size(), takeBenchmark ? "benchmark" : "preFill");

        final List<OrderCommand> merged = RandomCollectionsMerger.mergeCollections(commandsLists, seed);

        final CompletableFuture<List<ApiCommand>> resultFuture = runAfterThis.thenApplyAsync(ignore -> TestOrdersGenerator.convertToApiCommand(merged));

        if (takeBenchmark) {
            resultFuture.thenRunAsync(() -> printStatistics(merged));
        }

        return resultFuture;
    }

    public static double[] createWeightedDistribution(int size, int seed) {
        final RealDistribution paretoDistribution = new ParetoDistribution(new JDKRandomGenerator(seed), 0.001, 1.5);
        final double[] paretoRaw = DoubleStream.generate(paretoDistribution::sample).limit(size).toArray();

        // normalize
        final double sum = Arrays.stream(paretoRaw).sum();
        double[] doubles = Arrays.stream(paretoRaw).map(x -> x / sum).toArray();
//        Arrays.stream(doubles).sorted().forEach(d -> log.debug("{}", d));
        return doubles;
    }

    @NotNull
    public static LongConsumer createAsyncProgressLogger(int totalTransactionsNumber) {
        final long progressLogInterval = 5_000_000_000L; // 5 sec
        final AtomicLong nextUpdateTime = new AtomicLong(System.nanoTime() + progressLogInterval);
        final LongAdder progress = new LongAdder();
        return transactions -> {
            progress.add(transactions);
            final long whenLogNext = nextUpdateTime.get();
            final long timeNow = System.nanoTime();
            if (timeNow > whenLogNext) {
                if (nextUpdateTime.compareAndSet(whenLogNext, timeNow + progressLogInterval)) {
                    // whichever thread won - it should print progress
                    final long done = progress.sum();
                    log.debug(String.format("Generating commands progress: %.01f%% done (%d of %d)...",
                            done * 100.0 / totalTransactionsNumber, done, totalTransactionsNumber));
                }
            }
        };
    }

    // TODO generate ApiCommands (less GC load)
    public static GenResult generateCommands(
            final int benchmarkTransactionsNumber,
            final int targetOrderBookOrders,
            final int numUsers,
            final UnaryOperator<Integer> uidMapper,
            final int symbol,
            final boolean enableSlidingPrice,
            final boolean avalancheIOC,
            final LongConsumer asyncProgressConsumer,
            final int seed) {

        // TODO specify symbol type (for testing exchange-bid-move rejects)
        final IOrderBook orderBook = new OrderBookNaiveImpl(SYMBOLSPEC_EUR_USD, LoggingConfiguration.DEFAULT);
//        final IOrderBook orderBook = new OrderBookDirectImpl(SYMBOLSPEC_EUR_USD, ObjectsPool.createDefaultTestPool());

        final TestOrdersGeneratorSession session = new TestOrdersGeneratorSession(
                orderBook,
                benchmarkTransactionsNumber,
                targetOrderBookOrders / 2, // asks + bids
                avalancheIOC,
                numUsers,
                uidMapper,
                symbol,
                enableSlidingPrice,
                seed);

        final List<OrderCommand> commandsFill = new ArrayList<>(targetOrderBookOrders);
        final List<OrderCommand> commandsBenchmark = new ArrayList<>(benchmarkTransactionsNumber);

        int nextSizeCheck = Math.min(CHECK_ORDERBOOK_STAT_EVERY_NTH_COMMAND, targetOrderBookOrders + 1);

        final int totalCommandsNumber = benchmarkTransactionsNumber + targetOrderBookOrders;

        int lastProgressReported = 0;

        for (int i = 0; i < totalCommandsNumber; i++) {

            final boolean fillInProgress = i < targetOrderBookOrders;

            final OrderCommand cmd;

            if (fillInProgress) {
                cmd = generateRandomGtcOrder(session);
                commandsFill.add(cmd);
            } else {
                cmd = generateRandomOrder(session);
                commandsBenchmark.add(cmd);
            }

            cmd.resultCode = CommandResultCode.VALID_FOR_MATCHING_ENGINE;
            cmd.symbol = session.symbol;
            //log.debug("{}. {}", i, cmd);

            final CommandResultCode resultCode = IOrderBook.processCommand(orderBook, cmd);
            if (resultCode != CommandResultCode.SUCCESS) {
                throw new IllegalStateException("Unsuccessful result code: " + resultCode + " for " + cmd);
            }

            // process and cleanup matcher events
            cmd.processMatcherEvents(ev -> matcherTradeEventEventHandler(session, ev, cmd));
            cmd.matcherEvent = null;

            if (i >= nextSizeCheck) {

                nextSizeCheck += Math.min(CHECK_ORDERBOOK_STAT_EVERY_NTH_COMMAND, targetOrderBookOrders + 1);

                updateOrderBookSizeStat(session);
            }

            if (i % 10000 == 9999) {
                asyncProgressConsumer.accept(i - lastProgressReported);
                lastProgressReported = i;
            }
        }

        asyncProgressConsumer.accept(totalCommandsNumber - lastProgressReported);

        updateOrderBookSizeStat(session);

        final L2MarketData l2MarketData = orderBook.getL2MarketDataSnapshot(Integer.MAX_VALUE);

        return GenResult.builder()
                .commandsBenchmark(commandsBenchmark)
                .commandsFill(commandsFill)
                .finalOrderbookHash(orderBook.stateHash())
                .finalOrderBookSnapshot(l2MarketData)
                .build();
    }

    private static void updateOrderBookSizeStat(TestOrdersGeneratorSession session) {

        final int ordersNumAsk = session.orderBook.getOrdersNum(OrderAction.ASK);
        final int ordersNumBid = session.orderBook.getOrdersNum(OrderAction.BID);

        // log.debug("ask={}, bif={} seq={} filledAtSeq={}", ordersNumAsk, ordersNumBid, session.seq, session.filledAtSeq);

        // regulating OB size
        session.lastOrderBookOrdersSizeAsk = ordersNumAsk;
        session.lastOrderBookOrdersSizeBid = ordersNumBid;
//        log.debug("ordersNum:{}", ordersNum);

        if (session.initialOrdersPlaced || session.avalancheIOC) {
            final L2MarketData l2MarketDataSnapshot = session.orderBook.getL2MarketDataSnapshot(Integer.MAX_VALUE);
//                log.debug("{}", dumpOrderBook(l2MarketDataSnapshot));

            if (session.avalancheIOC) {
                session.lastTotalVolumeAsk = l2MarketDataSnapshot.totalOrderBookVolumeAsk();
                session.lastTotalVolumeBid = l2MarketDataSnapshot.totalOrderBookVolumeBid();
            }

            if (session.initialOrdersPlaced) {
                session.orderBookSizeAskStat.add(l2MarketDataSnapshot.askSize);
                session.orderBookSizeBidStat.add(l2MarketDataSnapshot.bidSize);
                session.orderBookNumOrdersAskStat.add(ordersNumAsk);
                session.orderBookNumOrdersBidStat.add(ordersNumBid);
            }
        }
    }

    private static void matcherTradeEventEventHandler(final TestOrdersGeneratorSession session, final MatcherTradeEvent ev, final OrderCommand orderCommand) {
        int activeOrderId = (int) orderCommand.orderId;
        if (ev.eventType == MatcherEventType.TRADE) {
            if (ev.activeOrderCompleted) {
                session.numCompleted++;
            }
            if (ev.matchedOrderCompleted) {
                session.orderUids.remove((int) ev.matchedOrderId);
                session.numCompleted++;
            }

            // decrease size (important for reduce operation)
            if (session.orderSizes.addToValue((int) ev.matchedOrderId, (int) -ev.size) < 0) {
                throw new IllegalStateException();
            }

            session.lastTradePrice = Math.min(session.maxPrice, Math.max(session.minPrice, ev.price));

            if (ev.price <= session.minPrice) {
                session.priceDirection = 1;
            } else if (ev.price >= session.maxPrice) {
                session.priceDirection = -1;
            }

        } else if (ev.eventType == MatcherEventType.REJECT) {
            session.numRejected++;

            // update order book stat if order get rejected
            // that will trigger generator to issue more limit orders
            updateOrderBookSizeStat(session);

        } else if (ev.eventType == MatcherEventType.REDUCE) {
            session.numReduced++;

        } else {
            return;
        }

        // decrease size (important for reduce operation)
        if (session.orderSizes.addToValue(activeOrderId, (int) -ev.size) < 0) {
            throw new IllegalStateException("Incorrect filled size for order " + activeOrderId);
        }

        if (ev.activeOrderCompleted) {
            session.orderUids.remove(activeOrderId);
        }
    }


    private static OrderCommand generateRandomOrder(TestOrdersGeneratorSession session) {

        final Random rand = session.rand;

        // TODO move to lastOrderBookOrdersSize writer method
        final int lackOfOrdersAsk = session.targetOrderBookOrdersHalf - session.lastOrderBookOrdersSizeAsk;
        final int lackOfOrdersBid = session.targetOrderBookOrdersHalf - session.lastOrderBookOrdersSizeBid;
        if (!session.initialOrdersPlaced && lackOfOrdersAsk <= 0 && lackOfOrdersBid <= 0) {
            session.initialOrdersPlaced = true;

            session.counterPlaceMarket = 0;
            session.counterPlaceLimit = 0;
            session.counterCancel = 0;
            session.counterMove = 0;
            session.counterReduce = 0;
        }

        final OrderAction action = (rand.nextInt(4) + session.priceDirection >= 2)
                ? OrderAction.BID
                : OrderAction.ASK;

        final int lackOfOrders = (action == OrderAction.ASK) ? lackOfOrdersAsk : lackOfOrdersBid;

        final boolean requireFastFill = session.filledAtSeq == null || lackOfOrders > session.lackOrOrdersFastFillThreshold;

        final boolean growOrders = lackOfOrders > 0;

        //log.debug("{} growOrders={} requireFastFill={} lackOfOrders({})={}", session.seq, growOrders, requireFastFill, action, lackOfOrders);

        if (session.filledAtSeq == null && !growOrders) {
            session.filledAtSeq = session.seq;
            //log.debug("Symbol {} filled at {} (targetOb={} trans={})", session.symbol, session.seq, session.targetOrderBookOrdersHalf, session.transactionsNumber);
        }

        final int q = rand.nextInt(growOrders
                ? (requireFastFill ? 2 : 10)
                : 40);

        if (q < 2 || session.orderUids.isEmpty()) {

            if (growOrders) {
                return generateRandomGtcOrder(session);
            } else {
                return generateRandomInstantOrder(session);
            }

        }

        // TODO improve random picking performance (custom hashset implementation?)
//        long t = System.nanoTime();
        int size = Math.min(session.orderUids.size(), 512);

        int randPos = rand.nextInt(size);
        Iterator<Map.Entry<Integer, Integer>> iterator = session.orderUids.entrySet().iterator();

        Map.Entry<Integer, Integer> rec = iterator.next();
        for (int i = 0; i < randPos; i++) {
            rec = iterator.next();
        }
//        session.hdrRecorder.recordValue(Math.min(System.nanoTime() - t, Integer.MAX_VALUE));
        int orderId = rec.getKey();

        int uid = rec.getValue();
        if (uid == 0) {
            throw new IllegalStateException();
        }

        if (q == 2) {
            session.orderUids.remove(orderId);
            session.counterCancel++;
            return OrderCommand.cancel(orderId, uid);

        } else if (q == 3) {
            session.counterReduce++;

            int prevSize = session.orderSizes.get(orderId);
            int reduceBy = session.rand.nextInt(prevSize) + 1;
            return OrderCommand.reduce(orderId, uid, reduceBy);

        } else {
            int prevPrice = session.orderPrices.get(orderId);
            if (prevPrice == 0) {
                throw new IllegalStateException();
            }

            double priceMove = (session.lastTradePrice - prevPrice) * CENTRAL_MOVE_ALPHA;
            int priceMoveRounded;
            if (prevPrice > session.lastTradePrice) {
                priceMoveRounded = (int) Math.floor(priceMove);
            } else if (prevPrice < session.lastTradePrice) {
                priceMoveRounded = (int) Math.ceil(priceMove);
            } else {
                priceMoveRounded = rand.nextInt(2) * 2 - 1;
            }

            final int newPrice = Math.min(prevPrice + priceMoveRounded, (int) session.maxPrice);
            // todo add min limit

            // log.debug("session.seq={} orderId={} size={} p={}", session.seq, orderId, session.actualOrders.size(), priceMoveRounded);

            session.counterMove++;

            session.orderPrices.put(orderId, newPrice);

            return OrderCommand.update(orderId, (int) (long) uid, newPrice);
        }
    }

    private static OrderCommand generateRandomGtcOrder(TestOrdersGeneratorSession session) {

        final Random rand = session.rand;

        final OrderAction action = (rand.nextInt(4) + session.priceDirection >= 2) ? OrderAction.BID : OrderAction.ASK;
        final int uid = session.uidMapper.apply(rand.nextInt(session.numUsers));
        final int newOrderId = session.seq;

        final int dev = 1 + (int) (Math.pow(rand.nextDouble(), 2) * session.priceDeviation);

        long p = 0;
        final int x = 4;
        for (int i = 0; i < x; i++) {
            p += rand.nextInt(dev);
        }
        p = p / x * 2 - dev;
        if (p > 0 ^ action == OrderAction.ASK) {
            p = -p;
        }

        //log.debug("p={} action={}", p, action);
        final int price = (int) session.lastTradePrice + (int) p;

        int size = 1 + rand.nextInt(6) * rand.nextInt(6) * rand.nextInt(6);


        session.orderPrices.put(newOrderId, price);
        session.orderSizes.put(newOrderId, size);
        session.orderUids.put(newOrderId, uid);
        session.counterPlaceLimit++;
        session.seq++;

        return OrderCommand.builder()
                .command(OrderCommandType.PLACE_ORDER)
                .uid(uid)
                .orderId(newOrderId)
                .action(action)
                .orderType(OrderType.GTC)
                .size(size)
                .price(price)
                .reserveBidPrice(action == OrderAction.BID ? session.maxPrice : 0)// set limit price
                .build();
    }

    private static OrderCommand generateRandomInstantOrder(TestOrdersGeneratorSession session) {

        final Random rand = session.rand;

        final OrderAction action = (rand.nextInt(4) + session.priceDirection >= 2) ? OrderAction.BID : OrderAction.ASK;

        final int uid = session.uidMapper.apply(rand.nextInt(session.numUsers));

        final int newOrderId = session.seq;

        final long priceLimit = action == OrderAction.BID ? session.maxPrice : session.minPrice;

        final long size;
        final OrderType orderType;
        final long priceOrBudget;
        final long reserveBidPrice;

        if (session.avalancheIOC) {

            // just match with available liquidity

            orderType = OrderType.IOC;
            priceOrBudget = priceLimit;
            reserveBidPrice = action == OrderAction.BID ? session.maxPrice : 0; // set limit price
            final long availableVolume = action == OrderAction.ASK ? session.lastTotalVolumeAsk : session.lastTotalVolumeBid;

            long bigRand = rand.nextLong();
            bigRand = bigRand < 0 ? -1 - bigRand : bigRand;
            size = 1 + bigRand % (availableVolume + 1);

            if (action == OrderAction.ASK) {
                session.lastTotalVolumeAsk = Math.max(session.lastTotalVolumeAsk - size, 0);
            } else {
                session.lastTotalVolumeBid = Math.max(session.lastTotalVolumeAsk - size, 0);
            }
//                    log.debug("huge size={} at {}", placeCmd.size, session.seq);

        } else if (rand.nextInt(32) == 0) {
            // IOC:FOKB = 31:1
            orderType = OrderType.FOK_BUDGET;
            size = 1 + rand.nextInt(8) * rand.nextInt(8) * rand.nextInt(8);

            // set budget-expectation
            priceOrBudget = size * priceLimit;
            reserveBidPrice = priceOrBudget;
        } else {
            orderType = OrderType.IOC;
            priceOrBudget = priceLimit;
            reserveBidPrice = action == OrderAction.BID ? session.maxPrice : 0; // set limit price
            size = 1 + rand.nextInt(6) * rand.nextInt(6) * rand.nextInt(6);
        }


        session.orderSizes.put(newOrderId, (int) size);
        session.counterPlaceMarket++;
        session.seq++;


        return OrderCommand.builder()
                .command(OrderCommandType.PLACE_ORDER)
                .orderType(orderType)
                .uid(uid)
                .orderId(newOrderId)
                .action(action)
                .size(size)
                .price(priceOrBudget)
                .reserveBidPrice(reserveBidPrice)
                .build();
    }

    public static List<ApiCommand> convertToApiCommand(TestOrdersGenerator.GenResult genResult) {
        final List<OrderCommand> commands = new ArrayList<>(genResult.commandsFill);
        commands.addAll(genResult.commandsBenchmark);
        return convertToApiCommand(commands, 0, commands.size());
    }

    public static List<ApiCommand> convertToApiCommand(List<OrderCommand> commands) {
        return convertToApiCommand(commands, 0, commands.size());
    }

    public static List<ApiCommand> convertToApiCommand(List<OrderCommand> commands, int from, int to) {
        try (ExecutionTime ignore = new ExecutionTime(t -> log.debug("Converted {} commands to API commands in: {}", to - from, t))) {
            ArrayList<ApiCommand> apiCommands = new ArrayList<>(to - from);
            for (int i = from; i < to; i++) {
                final OrderCommand cmd = commands.get(i);
                switch (cmd.command) {
                    case PLACE_ORDER:
                        apiCommands.add(ApiPlaceOrder.builder().symbol(cmd.symbol).uid(cmd.uid).orderId(cmd.orderId).price(cmd.price)
                                .size(cmd.size).action(cmd.action).orderType(cmd.orderType).reservePrice(cmd.reserveBidPrice).build());
                        break;

                    case MOVE_ORDER:
                        apiCommands.add(new ApiMoveOrder(cmd.orderId, cmd.price, cmd.uid, cmd.symbol));
                        break;

                    case CANCEL_ORDER:
                        apiCommands.add(new ApiCancelOrder(cmd.orderId, cmd.uid, cmd.symbol));
                        break;

                    case REDUCE_ORDER:
                        apiCommands.add(new ApiReduceOrder(cmd.orderId, cmd.uid, cmd.symbol, cmd.size));
                        break;

                    default:
                        throw new IllegalStateException("unsupported type: " + cmd.command);
                }
            }

            return apiCommands;
        }
    }

    private static void printStatistics(final List<OrderCommand> allCommands) {
        int counterPlaceIOC = 0;
        int counterPlaceGTC = 0;
        int counterPlaceFOKB = 0;
        int counterCancel = 0;
        int counterMove = 0;
        int counterReduce = 0;
        final IntIntHashMap symbolCounters = new IntIntHashMap();

        for (OrderCommand cmd : allCommands) {
            switch (cmd.command) {
                case MOVE_ORDER:
                    counterMove++;
                    break;

                case CANCEL_ORDER:
                    counterCancel++;
                    break;

                case REDUCE_ORDER:
                    counterReduce++;
                    break;

                case PLACE_ORDER:
                    if (cmd.orderType == OrderType.IOC) {
                        counterPlaceIOC++;
                    } else if (cmd.orderType == OrderType.GTC) {
                        counterPlaceGTC++;
                    } else if (cmd.orderType == OrderType.FOK_BUDGET) {
                        counterPlaceFOKB++;
                    }
                    break;
            }
            symbolCounters.addToValue(cmd.symbol, 1);
        }

        final int commandsListSize = allCommands.size();
        final IntSummaryStatistics symbolStat = symbolCounters.summaryStatistics();

        final String commandsGtc = String.format("%.2f%%", (float) counterPlaceGTC / (float) commandsListSize * 100.0f);
        final String commandsIoc = String.format("%.2f%%", (float) counterPlaceIOC / (float) commandsListSize * 100.0f);
        final String commandsFokb = String.format("%.2f%%", (float) counterPlaceFOKB / (float) commandsListSize * 100.0f);
        final String commandsCancel = String.format("%.2f%%", (float) counterCancel / (float) commandsListSize * 100.0f);
        final String commandsMove = String.format("%.2f%%", (float) counterMove / (float) commandsListSize * 100.0f);
        final String commandsReduce = String.format("%.2f%%", (float) counterReduce / (float) commandsListSize * 100.0f);
        log.info("GTC:{} IOC:{} FOKB:{} cancel:{} move:{} reduce:{}", commandsGtc, commandsIoc, commandsFokb, commandsCancel, commandsMove, commandsReduce);

        final String cpsMax = String.format("%d (%.2f%%)", symbolStat.getMax(), symbolStat.getMax() * 100.0f / commandsListSize);
        final String cpsAvg = String.format("%d (%.2f%%)", (int) symbolStat.getAverage(), symbolStat.getAverage() * 100.0f / commandsListSize);
        final String cpsMin = String.format("%d (%.2f%%)", symbolStat.getMin(), symbolStat.getMin() * 100.0f / commandsListSize);
        log.info("commands per symbol: max:{}; avg:{}; min:{}", cpsMax, cpsAvg, cpsMin);
    }

    @Builder
    @Getter
    public static class GenResult {
        final private L2MarketData finalOrderBookSnapshot;
        final private int finalOrderbookHash;
        final private List<OrderCommand> commandsFill;
        final private List<OrderCommand> commandsBenchmark;

        public Iterable<OrderCommand> getCommands() {
            return Iterables.concat(commandsFill, commandsBenchmark);
        }

        public int size() {
            return commandsFill.size() + commandsBenchmark.size();
        }
    }

    @Builder
    @Getter
    public static class MultiSymbolGenResult {
        final Map<Integer, TestOrdersGenerator.GenResult> genResults;
        final CompletableFuture<List<ApiCommand>> apiCommandsFill;
        final CompletableFuture<List<ApiCommand>> apiCommandsBenchmark;
        final int benchmarkCommandsSize;
    }
}
