WITH RoomUsage AS (
    SELECT 
        h.Hotel_ID,
        h.Hotel_Name,
        rt.Room_Size,
        SUM(ar.Total_Room) AS Total_Rooms,
        SUM(er.Room_Quantity) AS Reserved_Rooms,
        AVG(rt.Room_Price) AS Avg_Room_Price
    FROM Hotel h
    JOIN Available_Room_per_hotel ar ON h.Hotel_ID = ar.Hotel_ID
    JOIN Room_Type rt ON ar.Room_ID = rt.Room_ID
    LEFT JOIN Event_Reservation er ON ar.Room_ID = er.Room_ID AND h.Hotel_ID = er.Hotel_ID
    GROUP BY h.Hotel_ID, h.Hotel_Name, rt.Room_Size
),

EventStats AS (
    SELECT 
        et.Event_ID,
        et.Event_Name,
        COUNT(er.Event_Reservation_ID) AS Total_Bookings,
        SUM(er.No_Of_People) AS Total_People,
        AVG(er.Room_Invoice) AS Avg_Room_Invoice
    FROM Event_Type et
    JOIN Event_Reservation er ON et.Event_ID = er.Event_ID
    WHERE er.Status = 1  -- Reserved
    GROUP BY et.Event_ID, et.Event_Name
),

ServiceStats AS (
    SELECT 
        et.Event_ID,
        st.Service_Name,
        COUNT(sr.Service_Reservation_ID) AS Total_Services
    FROM Event_Type et
    JOIN Event_Reservation er ON et.Event_ID = er.Event_ID
    JOIN Service_Reservation sr ON er.Event_Reservation_ID = sr.Event_Reservation_ID
    JOIN Service_Type st ON sr.Service_ID = st.Service_ID
    WHERE er.Status = 1  -- Reserved
    GROUP BY et.Event_ID, st.Service_Name
),

GuestStats AS (
    SELECT 
        g.Guest_ID,
        g.Guest_Name,
        COUNT(DISTINCT er.Hotel_ID) AS Num_Hotels,
        COUNT(er.Event_Reservation_ID) AS Total_Reservations
    FROM Guest g
    JOIN Event_Reservation er ON g.Guest_ID = er.Guest_ID
    WHERE er.Status = 1  -- Reserved
    GROUP BY g.Guest_ID, g.Guest_Name
),

CombinedStats AS (
    SELECT 
        ru.Hotel_Name,
        ru.Room_Size,
        ru.Total_Rooms,
        ru.Reserved_Rooms,
        ru.Avg_Room_Price,
        es.Event_Name,
        es.Total_Bookings,
        es.Total_People,
        es.Avg_Room_Invoice,
        ss.Service_Name,
        ss.Total_Services,
        gs.Num_Hotels,
        gs.Total_Reservations
    FROM RoomUsage ru
    JOIN EventStats es ON ru.Hotel_ID = es.Event_ID  -- Assuming event ID relates to hotel ID
    LEFT JOIN ServiceStats ss ON es.Event_ID = ss.Event_ID
    LEFT JOIN GuestStats gs ON ru.Hotel_ID = gs.Num_Hotels  -- Linking guest stats
)

SELECT * FROM CombinedStats
ORDER BY Hotel_Name, Room_Size, Event_Name;

