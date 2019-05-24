package lt.getpet.getpet.persistence

import androidx.room.*

@Dao
interface PetDao {

    @Query("SELECT Pets.id FROM Pets INNER JOIN PetChoices ON Pets.id = PetChoices.pet_id " +
            "AND PetChoices.status = 1")
    fun getLikedPetIds(): List<Long>

    @Query("SELECT Pets.id FROM Pets INNER JOIN PetChoices ON Pets.id = PetChoices.pet_id " +
            "AND PetChoices.status = 2")
    fun getPetIdsWithRquests(): List<Long>

    @Query("SELECT Pets.id FROM Pets INNER JOIN PetChoices ON Pets.id = PetChoices.pet_id " +
            "AND PetChoices.status = 0")
    fun getDislikedPetIds(): List<Long>


}