package com.example.course_like_erip.repositories;


import com.example.course_like_erip.models.User;
import com.example.course_like_erip.models.Enum.Role;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface UserRepository extends JpaRepository<User, Long>{
    User findByEmail(String email);
    List<User> findAllByIdIn(List<Long> ids);
    @Query("SELECT u FROM User u WHERE u.verificationSubmitted = true AND u.verified = false")
    List<User> findByVerificationSubmittedTrueAndVerifiedFalse();
    List<User> findByRolesContainingAndVerifiedTrue(Role role);
    List<User> findByVerifiedTrue();
}
