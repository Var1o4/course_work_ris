package com.example.course_like_erip.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.example.course_like_erip.models.Operation;

public interface OperationRepository extends JpaRepository<Operation, Long> {
  
}
