package com.example.gps_tracking_system

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import android.widget.Toast

class FirebaseReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent?) {
        Log.d("FirebaseService", "Service tried to stop")
        Toast.makeText(context, "Service restarted", Toast.LENGTH_SHORT).show()

//        intent.getBundleExtra()
//        val intent = Intent(context, FirebaseService::class.java)
//        val bundle = intent?.getBundleExtra("firebaseWorkerId");
//        bundle.putString("worker_id", workerId)
//        intent.putExtra("firebaseWorkerId", bundle)
        Log.d("FirebaseService", "Start Service")

        var intent = Intent(context, FirebaseService::class.java)
        context.startService(intent)
    }
}