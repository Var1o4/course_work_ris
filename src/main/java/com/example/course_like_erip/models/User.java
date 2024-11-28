package com.example.course_like_erip.models;

import com.example.course_like_erip.models.Enum.Role;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.io.Serializable;
import java.time.LocalDateTime;
import java.util.*;

@Entity
@Table(name = "users")
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class User implements UserDetails, Serializable {
    private static final long serialVersionUID = 1905581085963556480L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    @Column(name = "email", unique = true)
    private String email;
    @Column(name = "phoneNumber")
    private String phoneNumber;
    @Column(name = "name")
    private String name;
    @Column(name = "active")
    private boolean active;
    @Column(name = "speciality")
    private String speciality;
    @Column(name = "expirience")
    private String expirience;
    @Column(name = "password", length = 1000)
    private String password;

    @Column(name = "address")
    private String address;
    @Column(name = "passportNumber")
    private String passportNumber;

    @Column(length = 1000000)
    private byte[] personalPhoto;
    @Column(length = 1000000)
    private byte[] passportPhoto;

    private boolean verificationSubmitted = false;
    private boolean verified = false;

    @ElementCollection(targetClass = Role.class, fetch = FetchType.EAGER)
    @CollectionTable(name="user_role",
            joinColumns = @JoinColumn(name="user_id"))
    @Enumerated(EnumType.STRING)
    private Set<Role> roles = new HashSet<>();


    private LocalDateTime dateOfCreated;

    @PrePersist
    private void init() {
        dateOfCreated = LocalDateTime.now();
    }


    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return roles;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return active;
    }


    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return Objects.equals(id, user.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", email='" + email +
                '}';
    }

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Payment> payments = new ArrayList<>();

    public boolean hasRole(String roleName) {
        return roles.stream()
                .anyMatch(role -> role.name().equals(roleName));
    }


    public boolean isBanned() {
        return !active;
    }



}
