package lt.getpet.getpet.data

import androidx.room.*
import androidx.room.ForeignKey.CASCADE

@Entity(tableName = "PetChoices",
        foreignKeys = [ForeignKey(entity = Pet::class,
                parentColumns = ["id"],
                childColumns = ["pet_id"],
                onDelete = CASCADE)],
        indices = [
            Index(value = ["pet_id"], unique = true)
        ]
)
data class PetChoice(
        @PrimaryKey(autoGenerate = true)
        @ColumnInfo(name = "id")
        val id: Long = 0,
        @ColumnInfo(name = "pet_id")
        val petId: Long,
        @ColumnInfo(name = "status", index = true)
        val status: Int,
        @ColumnInfo(name = "created_at")
        var createdAt: Long = System.currentTimeMillis()
) {
    companion object {
        const val STATUS_PET_DISLIKED = 0
        const val STATUS_PET_FAVORITE = 1
        const val STATUS_PET_WITH_GETPET_REQUEST = 2
    }
}

enum class PetChoiceStatus(val id: Int) {
    DISLIKED(PetChoice.STATUS_PET_DISLIKED),
    FAVORITE(PetChoice.STATUS_PET_FAVORITE),
    WITH_GETPET_REQUEST(PetChoice.STATUS_PET_WITH_GETPET_REQUEST)
}