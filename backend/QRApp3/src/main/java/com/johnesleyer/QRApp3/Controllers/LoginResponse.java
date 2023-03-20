package com.johnesleyer.QRApp3.Controllers;

public class LoginResponse {
    private String status;
    private long userId;
    private String userType;



    public LoginResponse(String status, long userId, String userType) {
        this.status = status;
        this.userId = userId;
        this.userType = userType;
    }


    public String getStatus() {
        return this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public long getUserId() {
        return this.userId;
    }

    public void setUserId(long userId) {
        this.userId = userId;
    }


    public String getUserType() {
        return this.userType;
    }

    public void setUserType(String userType) {
        this.userType = userType;
    }


}
