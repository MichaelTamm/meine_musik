package de.michaeltamm.meine_musik;

import android.content.ContentResolver;
import android.database.Cursor;
import android.media.MediaMetadataRetriever;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;

import androidx.annotation.NonNull;

import java.util.ArrayList;
import java.util.List;

public class AudioServiceImpl implements AudioApi.AudioService {

  public AudioServiceImpl(ContentResolver contentResolver) {
    this.contentResolver = contentResolver;
  }

  private final ContentResolver contentResolver;

  private static final String[] _projectionWithoutCdTrackNumber = {
    MediaStore.Audio.Media._ID,
    MediaStore.Audio.Media.DATA,
    MediaStore.Audio.Media.SIZE,
    MediaStore.Audio.Media.TITLE,
    MediaStore.Audio.Media.ARTIST,
    MediaStore.Audio.Media.ALBUM,
    MediaStore.Audio.Media.DURATION,
  };

  private static final String[] _projectionWithCdTrackNumber = {
    MediaStore.Audio.Media._ID,
    MediaStore.Audio.Media.DATA,
    MediaStore.Audio.Media.SIZE,
    MediaStore.Audio.Media.TITLE,
    MediaStore.Audio.Media.ARTIST,
    MediaStore.Audio.Media.ALBUM,
    MediaStore.Audio.Media.DURATION,
    MediaStore.Audio.Media.CD_TRACK_NUMBER,
  };

  @Override
  public void findAll(@NonNull AudioApi.Result<List<AudioApi.AudioFile>> result) {
    final List<AudioApi.AudioFile> audioFiles = new ArrayList<>();
    try {
      final int apiLevel = Build.VERSION.SDK_INT;
      final String[] projection = apiLevel < 30 ? _projectionWithoutCdTrackNumber : _projectionWithCdTrackNumber;
      for (final Uri uri : new Uri[]{MediaStore.Audio.Media.INTERNAL_CONTENT_URI, MediaStore.Audio.Media.EXTERNAL_CONTENT_URI}) {
        try (final Cursor cursor = contentResolver.query(
          uri,
          projection,
          MediaStore.Audio.Media.DATA + " NOT LIKE '/system/media/%'",
          null,
          null
        )) {
          if (cursor == null) {
            throw new RuntimeException("cursor == null");
          }
          try {
            while (cursor.moveToNext()) {
              final AudioApi.AudioFile audioFile = new AudioApi.AudioFile();
              audioFile.setId(cursor.getLong(0));
              audioFile.setPath(cursor.getString(1));
              audioFile.setSizeInBytes(cursor.getLong(2));
              audioFile.setTitle(_fixEncodingProblems(cursor.getString(3)));
              audioFile.setArtist(_fixEncodingProblems(cursor.getString(4)));
              audioFile.setAlbum(_fixEncodingProblems(cursor.getString(5)));
              audioFile.setDurationInMilliseconds(cursor.getLong(6));
              audioFile.setTrackNumber(apiLevel < 30 ? 0 : _parseTrackNumber(cursor.getString(7)));
              audioFiles.add(audioFile);
            }
          } finally {
            cursor.close();
          }
        }
      }
    } catch (RuntimeException e) {
      result.error(e);
      return;
    }
    result.success(audioFiles);
  }

  @Override
  public void getAlbumCover(@NonNull String path, @NonNull AudioApi.NullableResult<byte[]> result) {
    final MediaMetadataRetriever mmr = new MediaMetadataRetriever();
    try {
      mmr.setDataSource(path);
      byte[] albumCover = mmr.getEmbeddedPicture();
      result.success(albumCover);
    } catch (Exception e) {
      result.error(e);
    } finally {
      try {
        mmr.release();
      } catch (Exception ignored) {}
    }
  }

  static Long _parseTrackNumber(String s) {
    try {
      return Long.parseLong(s, 10);
    } catch (NumberFormatException ignored) {
      return 0L;
    }
  }

  static String _fixEncodingProblems(String s) {
    return s.replaceAll("â€™", "’");
  }
}
