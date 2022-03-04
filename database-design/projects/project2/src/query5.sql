use store;
SELECT *
FROM shop
WHERE end_time - start_time >= ALL (SELECT SH.end_time - SH.start_time
                                    FROM shop AS SH)