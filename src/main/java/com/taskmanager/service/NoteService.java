package com.taskmanager.service;

import com.taskmanager.model.Note;
import com.taskmanager.repository.NoteRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NoteService {

    @Autowired
    private NoteRepository noteRepository;

    public List<Note> getNotesByUserIdAndCategory(int userId, String category) {
        return noteRepository.findByUserIdAndCategoryOrderByUpdatedAtDesc(userId, category);
    }

    public List<Note> searchNotes(int userId, String category, String query) {
        if (query == null || query.trim().isEmpty()) {
            return getNotesByUserIdAndCategory(userId, category);
        }
        return noteRepository.searchNotes(userId, category, query.trim());
    }

    public Optional<Note> getNoteById(int id) {
        return noteRepository.findById(id);
    }

    public Note saveNote(Note note) {
        return noteRepository.save(note);
    }

    public void deleteNote(int id) {
        noteRepository.deleteById(id);
    }
}
