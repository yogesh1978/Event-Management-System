SELECT et.Event_Name, COUNT(er.Event_Reservation_ID) AS Booking_Count, AVG(rt.Room_Price) AS Avg_Room_Price
FROM Event_Type et
JOIN Event_Reservation er ON et.Event_ID = er.Event_ID
JOIN Room_Type rt ON er.Room_ID = rt.Room_ID
WHERE er.Room_Quantity > 50
GROUP BY et.Event_ID, et.Event_Name
HAVING COUNT(er.Event_Reservation_ID) > 5
ORDER BY Booking_Count DESC;
