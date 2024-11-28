package com.example.course_like_erip.repositories;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.course_like_erip.models.History;
import com.example.course_like_erip.models.User;

@Repository
public interface HistoryRepository extends JpaRepository<History, Long> {
    List<History> findByChangedByOrderByChangedAtDesc(User user);
    List<History> findByChangedByAndChangedAtAfterOrderByChangedAtDesc(User user, LocalDateTime startDate);
} 