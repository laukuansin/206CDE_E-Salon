package com.example.gps_tracking_system
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Color
import android.location.Location
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.*
import com.google.firebase.FirebaseApp
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase


class FirebaseService: Service() {


    private lateinit var database:DatabaseReference
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var workerId: String
    private  lateinit var  appointmentId:String
    lateinit var  dbHelper: DBHelper


    override fun onCreate() {
        super.onCreate()
        dbHelper = DBHelper(this)
        if (Build.VERSION.SDK_INT > Build.VERSION_CODES.O)
            startMyOwnForeground();
        else
            startForeground(1, Notification())
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun startMyOwnForeground() {
        val NOTIFICATION_CHANNEL_ID = "example.permanence"
        val channelName = "Background Service"
        val chan = NotificationChannel(NOTIFICATION_CHANNEL_ID, channelName, NotificationManager.IMPORTANCE_NONE)
        chan.setLightColor(Color.BLUE)
        chan.setLockscreenVisibility(Notification.VISIBILITY_PRIVATE)
        val manager: NotificationManager = (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
        manager.createNotificationChannel(chan)
        val notificationBuilder: NotificationCompat.Builder = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
        val notification: Notification = notificationBuilder.setOngoing(true)
                .setContentTitle("App is running in background")
                .setPriority(NotificationManager.IMPORTANCE_MIN)
                .setCategory(Notification.CATEGORY_SERVICE)
                .build()
        startForeground(2, notification)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        super.onStartCommand(intent, flags, startId)
        return START_STICKY;
    }

    override fun onBind(p0: Intent?): IBinder? {
        return null
    }

    override fun onStart(intent: Intent?, startId: Int) {
        super.onStart(intent, startId)
        val bundle = intent?.getBundleExtra("firebaseWorkerId")
        workerId = bundle?.get("worker_id") as String
        appointmentId = bundle.get("appointment_id") as String
        Log.d("FirebaseService", workerId)

        FirebaseApp.initializeApp(this)
        database = Firebase.database.reference
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        val locationRequest = LocationRequest.create()
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY).setInterval(1).fastestInterval = 1

        val locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult?) {
                locationResult ?: return
                updateLocation(locationResult.lastLocation)
                dbHelper.insertRoute(appointmentId, locationResult.lastLocation.latitude, locationResult.lastLocation.longitude)
            }
        }

        if (ContextCompat.checkSelfPermission(this, android.Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED)
            fusedLocationClient.requestLocationUpdates(locationRequest, locationCallback, Looper.getMainLooper());

    }


    private fun updateLocation(location: Location){
        var data = HashMap<String, Double>();
        data["Lat"] = location.latitude
        data["Lng"] = location.longitude
        Log.d("FirebaseService", "Updating location ${location.latitude}, ${location.longitude}")
        database.child("Worker").child(workerId).setValue(data)
    }

    override fun onDestroy() {
//        Log.d("FirebaseService", "destory: ")
//        val bundle = Bundle()
//        bundle.putString("worker_id", workerId)
//
//        var rootIntent = Intent()
//        rootIntent.action = "restartservice";
//        rootIntent.setClass(this, FirebaseReceiver::class.java)
//        rootIntent.putExtra("firebaseWorkerId", bundle)
//        sendBroadcast(rootIntent)
        super.onDestroy()
    }



    override fun onTaskRemoved(rootIntent: Intent?) {
//        Log.d("FirebaseService", "onTaskRemoved: ")
//        val bundle = Bundle()
//        bundle.putString("worker_id", workerId)
//
//        var rootIntent = Intent()
//        rootIntent.action = "restartservice";
//        rootIntent.setClass(this, FirebaseReceiver::class.java)
//        rootIntent.putExtra("firebaseWorkerId", bundle)
//        sendBroadcast(rootIntent)
        super.onTaskRemoved(rootIntent)
    }
}