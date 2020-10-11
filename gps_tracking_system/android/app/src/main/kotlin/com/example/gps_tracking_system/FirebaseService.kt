package com.example.gps_tracking_system
import android.app.Service
import android.content.Intent
import android.content.pm.PackageManager
import android.location.Location
import android.os.IBinder
import android.os.Looper
import android.util.Log
import androidx.core.content.ContextCompat
import com.google.android.gms.location.*
import com.google.firebase.database.ktx.database
import com.google.firebase.ktx.Firebase
import com.google.firebase.FirebaseApp
import com.google.firebase.database.DatabaseReference


class FirebaseService: Service() {


    private lateinit var database:DatabaseReference
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private lateinit var workerId: String


    override fun onBind(p0: Intent?): IBinder? {
        return null
    }

    override fun onStart(intent: Intent?, startId: Int) {
        super.onStart(intent, startId)
        val bundle = intent?.getBundleExtra("firebaseWorkerId")
        workerId = bundle?.get("worker_id") as String
        Log.d("FirebaseService", workerId)

        FirebaseApp.initializeApp(this)
        database = Firebase.database.reference
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        val locationRequest = LocationRequest.create()
        locationRequest.setPriority(LocationRequest.PRIORITY_HIGH_ACCURACY).setInterval(1).fastestInterval = 0

        val locationCallback = object : LocationCallback() {
            override fun onLocationResult(locationResult: LocationResult?) {
                locationResult ?: return
                updateLocation(locationResult.lastLocation)
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
}