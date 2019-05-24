package lt.getpet.getpet.data

import androidx.room.ColumnInfo
import androidx.room.Embedded
import androidx.room.Entity
import androidx.room.PrimaryKey
import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@Entity(tableName = "Pets")
@JsonClass(generateAdapter = true)
data class Pet(
        @PrimaryKey
        @ColumnInfo(name = "id")
        val id: Long,
        @ColumnInfo(name = "name")
        val name: String,
        @Embedded(prefix = "shelter")
        val shelter: Shelter,
        @ColumnInfo(name = "photo")
        val photo: String,
        @ColumnInfo(name = "short_description")
        @Json(name = "short_description")
        val shortDescription: String,
        @ColumnInfo(name = "description")
        val description: String,
        @ColumnInfo(name = "photos")
        @Json(name = "profile_photos")
        val photos: List<PetPhoto> = emptyList(),
        @ColumnInfo(name = "is_available")
        @Json(name = "is_available")
        val available: Boolean = true
) {
    fun allPhotos(): List<String> {
        return listOf(photo) + photos.map { it.photo }
    }
}