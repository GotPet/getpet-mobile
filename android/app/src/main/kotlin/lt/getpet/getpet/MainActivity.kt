package lt.getpet.getpet

import android.os.Bundle
import androidx.room.Room

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;


import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import lt.getpet.getpet.persistence.Migrations
import lt.getpet.getpet.persistence.PetsDatabase
import lt.getpet.getpet.persistence.PetDao

class MainActivity : FlutterActivity() {
    companion object {
        const val CHANNEL = "lt.getpet.getpet"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getLegacyPets") {
                val db = Room.databaseBuilder(
                        applicationContext,
                        PetsDatabase::class.java,
                        "Pets.db"
                ).addMigrations(Migrations.MIGRATION_3_4)
                        .allowMainThreadQueries()
                        .fallbackToDestructiveMigration()
                        .build()

                val petsDao = db.petsDao()

                result.success(mapOf<String, List<Long>>(
                        "liked_pet_ids" to petsDao.getLikedPetIds(),
                        "with_requests_pet_ids" to petsDao.getPetIdsWithRequests()
                ))
            } else {
                result.notImplemented()
            }
        }
    }
}
