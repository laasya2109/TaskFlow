package com.taskmanager.repository;

import com.taskmanager.model.Note;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface NoteRepository extends JpaRepository<Note, Integer> {
    List<Note> findByUserIdAndCategoryOrderByUpdatedAtDesc(int userId, String category);

    @Query("SELECT n FROM Note n WHERE n.userId = :userId AND n.category = :category AND (lower(n.title) LIKE lower(concat('%', :query, '%')) OR lower(n.content) LIKE lower(concat('%', :query, '%'))) ORDER BY n.updatedAt DESC")
    List<Note> searchNotes(@Param("userId") int userId, @Param("category") String category, @Param("query") String query);
}
