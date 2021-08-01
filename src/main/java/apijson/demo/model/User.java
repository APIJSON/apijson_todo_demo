package apijson.demo.model;

import apijson.orm.Visitor;
import com.alibaba.fastjson.annotation.JSONField;

import java.util.List;

public class User implements Visitor<Long> {
    Long id;
    String username;
    String realname;
    String bio;

    List<Long> friends;

    public Long getId() {
        return id;
    }

    @JSONField(serialize = false)
    @Override
    public List<Long> getContactIdList() {
//        return Collections.emptyList();
        return getFriends();
    }

    public User setId(Long id) {
        this.id = id;
        return this;
    }

    public String getUsername() {
        return username;
    }

    public User setUsername(String username) {
        this.username = username;
        return this;
    }

    public String getRealname() {
        return realname;
    }

    public User setRealname(String realname) {
        this.realname = realname;
        return this;
    }

    public String getBio() {
        return bio;
    }

    public User setBio(String bio) {
        this.bio = bio;
        return this;
    }


    public List<Long> getFriends() {
        return friends;
    }

    public User setFriends(List<Long> friends) {
        this.friends = friends;
        return this;
    }


    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", realname='" + realname + '\'' +
                ", note='" + bio + '\'' +
                '}';
    }
}
