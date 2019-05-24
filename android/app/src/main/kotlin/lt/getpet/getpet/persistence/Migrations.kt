package lt.getpet.getpet.persistence

import androidx.room.migration.Migration
import androidx.sqlite.db.SupportSQLiteDatabase


object Migrations {
    val MIGRATION_3_4: Migration = object : Migration(3, 4) {
        override fun migrate(database: SupportSQLiteDatabase) {
            database.execSQL("ALTER TABLE Pets ADD COLUMN is_available INTEGER NOT NULL DEFAULT 1;")
        }
    }
}