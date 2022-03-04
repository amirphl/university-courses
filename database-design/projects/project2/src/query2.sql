use store;
SELECT phone_number
FROM rejected1
UNION
SELECT phone_number
FROM rejected2;