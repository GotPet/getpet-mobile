package lt.getpet.getpet


import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.room.Room
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import lt.getpet.getpet.persistence.Migrations
import lt.getpet.getpet.persistence.PetsDatabase
import kotlin.concurrent.thread

class MainActivity : FlutterActivity() {
    companion object {
        const val CHANNEL = "lt.getpet.getpet"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->

            if (call.method == "getLegacyPets") {
                thread {
                    val db = Room.databaseBuilder(
                            applicationContext,
                            PetsDatabase::class.java,
                            "Pets.db"
                    ).addMigrations(Migrations.MIGRATION_3_4)
                            .fallbackToDestructiveMigration()
                            .build()

                    val petsDao = db.petsDao()
                    val linkedPetIds = petsDao.getLikedPetIds()
                    val petIdsWithRequest = petsDao.getPetIdsWithRequests()

                    runOnUiThread {
                        result.success(
                                mapOf(
                                        "linkedPetIds" to linkedPetIds,
                                        "petIdsWithRequest" to petIdsWithRequest
                                )
                        )
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
