SELECT g.Guest_Name, COUNT(DISTINCT er.Hotel_ID) AS Num_Hotels
FROM Guest g
JOIN Event_Reservation er ON g.Guest_ID = er.Guest_ID
WHERE er.Status = 1  -- Reserved
GROUP BY g.Guest_ID, g.Guest_Name
ORDER BY Num_Hotels DESC
LIMIT 1;
