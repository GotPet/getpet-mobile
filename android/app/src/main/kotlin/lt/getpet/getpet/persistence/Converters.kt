package lt.getpet.getpet.persistence

import androidx.room.TypeConverter
import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.Moshi
import com.squareup.moshi.Types
import lt.getpet.getpet.data.PetPhoto

class Converters {

    private val moshi = Moshi.Builder().build()
    val moshiPetPhotosAdapter: JsonAdapter<List<PetPhoto>> = moshi.adapter(
            Types.newParameterizedType(List::class.java, PetPhoto::class.java)
    )

    @TypeConverter
    fun stringListToJson(value: List<PetPhoto>?): String {
        return moshiPetPhotosAdapter.toJson(value)
    }

    @TypeConverter
    fun jsonToStringList(value: String): List<PetPhoto>? {
        return moshiPetPhotosAdapter.fromJson(value)
    }
}