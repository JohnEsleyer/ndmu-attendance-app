package com.johnesleyer.QRApp3;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class LoginService {
    @Autowired
    private LoginRepository userRepository;

    public Login login(String username, String password) {
        return userRepository.findByUsernameAndPassword(username, password);
    }
}
