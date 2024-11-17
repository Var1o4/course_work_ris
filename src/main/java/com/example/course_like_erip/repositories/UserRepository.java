package com.example.course_like_erip.repositories;


import com.example.course_like_erip.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface UserRepository extends JpaRepository<User, Long>{
    User findByEmail(String email);
    List<User> findAllByIdIn(List<Long> ids);
    List<User> findByVerificationSubmittedTrueAndVerifiedFalse();
}
