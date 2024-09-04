SELECT h.Hotel_Name, rt.Room_Size, 
       COALESCE(SUM(ar.Total_Room), 0) AS Total_Rooms, 
       COALESCE(SUM(er.Room_Quantity), 0) AS Reserved_Rooms
FROM Hotel h
JOIN Available_Room_per_hotel ar ON h.Hotel_ID = ar.Hotel_ID
JOIN Room_Type rt ON ar.Room_ID = rt.Room_ID
LEFT JOIN Event_Reservation er ON ar.Room_ID = er.Room_ID AND h.Hotel_ID = er.Hotel_ID
GROUP BY h.Hotel_Name, rt.Room_Size
ORDER BY h.Hotel_Name, rt.Room_Size;
