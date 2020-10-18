package com.example.gps_tracking_system

import android.content.ContentValues
import android.content.Context
import android.database.sqlite.SQLiteConstraintException
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper
import android.util.Log


class DBHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {
    override fun onCreate(db: SQLiteDatabase) {
        db.execSQL(SQL_CREATE_ENTRIES)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        // This database is only a cache for online data, so its upgrade policy is
        // to simply to discard the data and start over
        db.execSQL(SQL_DELETE_ENTRIES)
        onCreate(db)
    }

    override fun onDowngrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        onUpgrade(db, oldVersion, newVersion)
    }

    @Throws(SQLiteConstraintException::class)
    fun insertRoute(id:String, lat:Double, lng:Double): Boolean {
        // Gets the data repository in write mode
        val db = writableDatabase

        // Create a new map of values, where column names are the keys
        val values = ContentValues()
        values.put(DBContract.UserEntry.COLUMN_APPOINTMENT_ID, id)
        values.put(DBContract.UserEntry.COLUMN_LAT, lat)
        values.put(DBContract.UserEntry.COLUMN_LNG, lng)

        // Insert the new row, returning the primary key value of the new row
        val newRowId = db.insert(DBContract.UserEntry.TABLE_NAME, null, values)
        Log.d("DB SQLLITE", "Inserted id was $newRowId");
        return true
    }

    companion object {
        // If you change the database schema, you must increment the database version.
        val DATABASE_VERSION = 1
        val DATABASE_NAME = "route.db"

        private val SQL_CREATE_ENTRIES =
                "CREATE TABLE IF NOT EXISTS " + DBContract.UserEntry.TABLE_NAME + " (" +
                        DBContract.UserEntry.COLUMN_ROUTEID + " INTEGER PRIMARY KEY AUTOINCREMENT, " +
                        DBContract.UserEntry.COLUMN_APPOINTMENT_ID + " TEXT," +
                        DBContract.UserEntry.COLUMN_LAT + " REAL," +
                        DBContract.UserEntry.COLUMN_LNG + " REAL)"


        private val SQL_DELETE_ENTRIES = "DROP TABLE IF EXISTS " + DBContract.UserEntry.TABLE_NAME
    }

}
