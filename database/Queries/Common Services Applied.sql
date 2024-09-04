SELECT st.Service_Name, COUNT(sr.Service_Reservation_ID) AS Reservation_Count
FROM Service_Type st
JOIN Service_Reservation sr ON st.Service_ID = sr.Service_ID
JOIN Event_Reservation er ON sr.Event_Reservation_ID = er.Event_Reservation_ID
WHERE er.Status = 3  -- Finished
AND er.Start_Date >= CURRENT_DATE - INTERVAL '6 MONTH'
GROUP BY st.Service_ID, st.Service_Name
ORDER BY Reservation_Count DESC
LIMIT 1;
