package lt.getpet.getpet.data

import android.os.Parcelable
import androidx.room.ColumnInfo
import com.squareup.moshi.JsonClass


@JsonClass(generateAdapter = true)
data class Shelter(
        @ColumnInfo(name = "id")
        val id: Long,
        @ColumnInfo(name = "name")
        val name: String,
        @ColumnInfo(name = "email")
        val email: String,
        @ColumnInfo(name = "phone")
        val phone: String
)