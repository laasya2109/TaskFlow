package com.taskmanager.controller;

import com.taskmanager.model.Note;
import com.taskmanager.model.User;
import com.taskmanager.service.NoteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/notes")
public class NoteController {

    @Autowired
    private NoteService noteService;

    @GetMapping
    public String listNotes(@RequestParam(value = "q", required = false) String query,
                            @RequestParam(value = "id", required = false) Integer selectedId,
                            HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        String category = (String) session.getAttribute("activeCategory");
        if (category == null || category.trim().isEmpty()) {
            return "redirect:/select-category.jsp";
        }

        List<Note> notes = noteService.searchNotes(user.getId(), category, query);
        model.addAttribute("notes", notes);
        model.addAttribute("query", query);

        if (selectedId != null) {
            Optional<Note> selectedNote = noteService.getNoteById(selectedId);
            if (selectedNote.isPresent() && selectedNote.get().getUserId() == user.getId()) {
                model.addAttribute("selectedNote", selectedNote.get());
            }
        }

        return "notes";
    }

    @PostMapping("/save")
    public String saveNote(@RequestParam(value = "id", required = false) Integer id,
                           @RequestParam("title") String title,
                           @RequestParam("content") String content,
                           HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        String category = (String) session.getAttribute("activeCategory");
        if (category == null || category.trim().isEmpty()) {
            category = "Personal";
        }

        boolean isNew = (id == null || id <= 0);

        Note note;
        if (id != null && id > 0) {
            Optional<Note> optNote = noteService.getNoteById(id);
            if (optNote.isPresent() && optNote.get().getUserId() == user.getId()) {
                note = optNote.get();
                note.setTitle(title);
                note.setContent(content);
            } else {
                return "redirect:/notes";
            }
        } else {
            note = new Note(0, title, content, user.getId(), category);
        }

        Note saved = noteService.saveNote(note);

        return "redirect:/notes?id=" + saved.getId();
    }

    @GetMapping("/delete")
    public String deleteNote(@RequestParam("id") int id, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login.jsp";
        }

        Optional<Note> optNote = noteService.getNoteById(id);
        if (optNote.isPresent() && optNote.get().getUserId() == user.getId()) {
            noteService.deleteNote(id);
        }

        return "redirect:/notes";
    }
}
