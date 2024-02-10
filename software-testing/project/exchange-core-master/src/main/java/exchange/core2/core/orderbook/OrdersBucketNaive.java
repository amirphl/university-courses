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
package exchange.core2.core.orderbook;

import exchange.core2.core.common.IOrder;
import exchange.core2.core.common.MatcherTradeEvent;
import exchange.core2.core.common.Order;
import exchange.core2.core.common.OrderAction;
import exchange.core2.core.utils.SerializationUtils;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.ToString;
import lombok.extern.slf4j.Slf4j;
import net.openhft.chronicle.bytes.BytesIn;
import net.openhft.chronicle.bytes.BytesOut;
import net.openhft.chronicle.bytes.WriteBytesMarshallable;

import java.util.*;
import java.util.function.Consumer;
import java.util.stream.Collectors;

@Slf4j
@ToString
public final class OrdersBucketNaive implements Comparable<OrdersBucketNaive>, WriteBytesMarshallable {

    @Getter
    private final long price;

    private final LinkedHashMap<Long, Order> entries;

    @Getter
    private long totalVolume;

    public OrdersBucketNaive(final long price) {
        this.price = price;
        this.entries = new LinkedHashMap<>();
        this.totalVolume = 0;
    }

    public OrdersBucketNaive(BytesIn bytes) {
        this.price = bytes.readLong();
        this.entries = SerializationUtils.readLongMap(bytes, LinkedHashMap::new, Order::new);
        this.totalVolume = bytes.readLong();
    }

    /**
     * Put a new order into bucket
     *
     * @param order - order
     */
    public void put(Order order) {
        entries.put(order.orderId, order);
        totalVolume += order.size - order.filled;
    }

    /**
     * Remove order from the bucket
     *
     * @param orderId - order id
     * @param uid     - order uid
     * @return order if removed, or null if not found
     */
    public Order remove(long orderId, long uid) {
        Order order = entries.get(orderId);
//        log.debug("removing order: {}", order);
        if (order == null || order.uid != uid) {
            return null;
        }

        entries.remove(orderId);

        totalVolume -= order.size - order.filled;
        return order;
    }

    /**
     * Collect a list of matching orders starting from eldest records
     * Completely matching orders will be removed, partially matched order kept in the bucked.
     *
     * @param volumeToCollect - volume to collect
     * @param activeOrder     - for getReserveBidPrice
     * @param helper          - events helper
     * @return - total matched volume, events, completed orders to remove
     */
    public MatcherResult match(long volumeToCollect, IOrder activeOrder, OrderBookEventsHelper helper) {

//        log.debug("---- match: {}", volumeToCollect);

        final Iterator<Map.Entry<Long, Order>> iterator = entries.entrySet().iterator();

        long totalMatchingVolume = 0;

        final List<Long> ordersToRemove = new ArrayList<>();

        MatcherTradeEvent eventsHead = null;
        MatcherTradeEvent eventsTail = null;

        // iterate through all orders
        while (iterator.hasNext() && volumeToCollect > 0) {
            final Map.Entry<Long, Order> next = iterator.next();
            final Order order = next.getValue();

            // calculate exact volume can fill for this order
//            log.debug("volumeToCollect={} order: s{} f{}", volumeToCollect, order.size, order.filled);
            final long v = Math.min(volumeToCollect, order.size - order.filled);
            totalMatchingVolume += v;
//            log.debug("totalMatchingVolume={} v={}", totalMatchingVolume, v);

            order.filled += v;
            volumeToCollect -= v;
            totalVolume -= v;

            // remove from order book filled orders
            final boolean fullMatch = order.size == order.filled;

            final long bidderHoldPrice = order.action == OrderAction.ASK ? activeOrder.getReserveBidPrice() : order.reserveBidPrice;
            final MatcherTradeEvent tradeEvent = helper.sendTradeEvent(order, fullMatch, volumeToCollect == 0, v, bidderHoldPrice);

            if (eventsTail == null) {
                eventsHead = tradeEvent;
            } else {
                eventsTail.nextEvent = tradeEvent;
            }
            eventsTail = tradeEvent;

            if (fullMatch) {
                ordersToRemove.add(order.orderId);
                iterator.remove();
            }
        }

        return new MatcherResult(eventsHead, eventsTail, totalMatchingVolume, ordersToRemove);
    }

    /**
     * Get number of orders in the bucket
     *
     * @return number of orders in the bucket
     */
    public int getNumOrders() {
        return entries.size();
    }

    /**
     * Reduce size of the order
     *
     * @param reduceSize - size to reduce (difference)
     */
    public void reduceSize(long reduceSize) {

        totalVolume -= reduceSize;
    }

    public void validate() {
        long sum = entries.values().stream().mapToLong(c -> c.size - c.filled).sum();
        if (sum != totalVolume) {
            String msg = String.format("totalVolume=%d calculated=%d", totalVolume, sum);
            throw new IllegalStateException(msg);
        }
    }

    public Order findOrder(long orderId) {
        return entries.get(orderId);
    }

    /**
     * Inefficient method - for testing only
     *
     * @return new array with references to orders, preserving execution queue order
     */
    public List<Order> getAllOrders() {
        return new ArrayList<>(entries.values());
    }


    /**
     * execute some action for each order (preserving execution queue order)
     *
     * @param consumer action consumer function
     */
    public void forEachOrder(Consumer<Order> consumer) {
        entries.values().forEach(consumer);
    }

    public String dumpToSingleLine() {
        String orders = getAllOrders().stream()
                .map(o -> String.format("id%d_L%d_F%d", o.orderId, o.size, o.filled))
                .collect(Collectors.joining(", "));

        return String.format("%d : vol:%d num:%d : %s", getPrice(), getTotalVolume(), getNumOrders(), orders);
    }

    @Override
    public void writeMarshallable(BytesOut bytes) {
        bytes.writeLong(price);
        SerializationUtils.marshallLongMap(entries, bytes);
        bytes.writeLong(totalVolume);
    }

    @Override
    public int compareTo(OrdersBucketNaive other) {
        return Long.compare(this.getPrice(), other.getPrice());
    }

    @Override
    public int hashCode() {
        return Objects.hash(
                price,
                Arrays.hashCode(entries.values().toArray(new Order[0])));
    }

    @Override
    public boolean equals(Object o) {
        if (o == this) return true;
        if (o == null) return false;
        if (!(o instanceof OrdersBucketNaive)) return false;
        OrdersBucketNaive other = (OrdersBucketNaive) o;
        return price == other.getPrice()
                && getAllOrders().equals(other.getAllOrders());
    }

    @AllArgsConstructor
    public final class MatcherResult {
        public MatcherTradeEvent eventsChainHead;
        public MatcherTradeEvent eventsChainTail;
        public long volume;
        public List<Long> ordersToRemove;
    }

}
