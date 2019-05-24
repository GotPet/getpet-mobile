package lt.getpet.getpet.persistence

import androidx.room.Database
import androidx.room.RoomDatabase
import androidx.room.TypeConverters
import lt.getpet.getpet.data.Pet
import lt.getpet.getpet.data.PetChoice

@Database(entities = [Pet::class, PetChoice::class], version = 4)
@TypeConverters(Converters::class)

abstract class PetsDatabase : RoomDatabase() {

    abstract fun petsDao(): PetDao
}