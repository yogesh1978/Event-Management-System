SELECT h.Hotel_Name, AVG(rt.Room_Price) AS Avg_Room_Price, COUNT(sr.Service_Reservation_ID) AS Total_Services
FROM Hotel h
JOIN Event_Reservation er ON h.Hotel_ID = er.Hotel_ID
JOIN Room_Type rt ON er.Room_ID = rt.Room_ID
JOIN Service_Reservation sr ON er.Event_Reservation_ID = sr.Event_Reservation_ID
WHERE er.Start_Date >= CURRENT_DATE - INTERVAL '1 MONTH'
AND er.Status = 1  -- Reserved
GROUP BY h.Hotel_ID, h.Hotel_Name
ORDER BY Avg_Room_Price DESC, Total_Services DESC
LIMIT 1;
