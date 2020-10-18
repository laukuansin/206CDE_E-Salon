package com.example.gps_tracking_system

import android.provider.BaseColumns

object DBContract {

    /* Inner class that defines the table contents */
    class UserEntry : BaseColumns {
        companion object {
            val TABLE_NAME = "Route"
            val COLUMN_ROUTEID = "route_id"
            val COLUMN_APPOINTMENT_ID = "appointment_id"
            val COLUMN_LAT = "lat"
            val COLUMN_LNG = "lng"
        }
    }
}