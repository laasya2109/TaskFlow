package com.taskmanager.service;

import com.taskmanager.model.User;
import com.taskmanager.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepository;

    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

    public Optional<User> authenticate(String username, String password) {
        Optional<User> userOpt = userRepository.findByUsername(username);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            String storedPassword = user.getPassword();

            if (storedPassword != null && storedPassword.startsWith("$2")) {
                if (passwordEncoder.matches(password, storedPassword)) {
                    return Optional.of(user);
                }
            } else if (storedPassword != null && storedPassword.equals(password)) {
                // Legacy plaintext match: upgrade to BCrypt hash
                user.setPassword(passwordEncoder.encode(password));
                userRepository.save(user);
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    public User registerUser(User user) {
        if (userRepository.existsByUsername(user.getUsername())) {
            throw new IllegalArgumentException("Username already exists");
        }
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        return userRepository.save(user);
    }

    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    public Optional<User> findById(int id) {
        return userRepository.findById(id);
    }
}
