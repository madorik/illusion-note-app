import 'package:dio/dio.dart';
import '../core/models/note_model.dart';
import 'api_service.dart';

class NoteService {
  final ApiService _apiService = ApiService();

  // 모든 노트 조회
  Future<List<Note>> getNotes({
    int page = 1,
    int limit = 20,
    String? category,
    String? emotion,
    String? search,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };
      
      if (category != null) queryParams['category'] = category;
      if (emotion != null) queryParams['emotion'] = emotion;
      if (search != null) queryParams['search'] = search;

      final response = await _apiService.get('/api/notes', queryParameters: queryParams);
      
      if (response.data['success'] == true) {
        final List<dynamic> notesData = response.data['data'] ?? [];
        return notesData.map((json) => Note.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch notes');
      }
    } catch (e) {
      throw Exception('Failed to fetch notes: $e');
    }
  }

  // 특정 노트 조회
  Future<Note> getNoteById(String id) async {
    try {
      final response = await _apiService.get('/api/notes/$id');
      
      if (response.data['success'] == true) {
        return Note.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch note');
      }
    } catch (e) {
      throw Exception('Failed to fetch note: $e');
    }
  }

  // 노트 생성
  Future<Note> createNote(Note note) async {
    try {
      final response = await _apiService.post('/api/notes', data: note.toJson());
      
      if (response.data['success'] == true) {
        return Note.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create note');
      }
    } catch (e) {
      throw Exception('Failed to create note: $e');
    }
  }

  // 노트 수정
  Future<Note> updateNote(String id, Note note) async {
    try {
      final response = await _apiService.put('/api/notes/$id', data: note.toJson());
      
      if (response.data['success'] == true) {
        return Note.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update note');
      }
    } catch (e) {
      throw Exception('Failed to update note: $e');
    }
  }

  // 노트 삭제
  Future<bool> deleteNote(String id) async {
    try {
      final response = await _apiService.delete('/api/notes/$id');
      
      if (response.data['success'] == true) {
        return true;
      } else {
        throw Exception(response.data['message'] ?? 'Failed to delete note');
      }
    } catch (e) {
      throw Exception('Failed to delete note: $e');
    }
  }

  // 사용자별 노트 조회
  Future<List<Note>> getUserNotes(String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '/api/users/$userId/notes',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      
      if (response.data['success'] == true) {
        final List<dynamic> notesData = response.data['data'] ?? [];
        return notesData.map((json) => Note.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch user notes');
      }
    } catch (e) {
      throw Exception('Failed to fetch user notes: $e');
    }
  }

  // 노트 검색
  Future<List<Note>> searchNotes(String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        '/api/notes/search',
        queryParameters: {
          'q': query,
          'page': page,
          'limit': limit,
        },
      );
      
      if (response.data['success'] == true) {
        final List<dynamic> notesData = response.data['data'] ?? [];
        return notesData.map((json) => Note.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to search notes');
      }
    } catch (e) {
      throw Exception('Failed to search notes: $e');
    }
  }

  // 감정별 노트 통계
  Future<Map<String, int>> getEmotionStats() async {
    try {
      final response = await _apiService.get('/api/notes/stats/emotions');
      
      if (response.data['success'] == true) {
        return Map<String, int>.from(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch emotion stats');
      }
    } catch (e) {
      throw Exception('Failed to fetch emotion stats: $e');
    }
  }
} 