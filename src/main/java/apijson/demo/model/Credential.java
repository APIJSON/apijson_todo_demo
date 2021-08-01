package apijson.demo.model;

import java.util.Collections;
import java.util.List;

public class Credential {

    Long id;
    String pwdHash;

    public Long getId() {
        return id;
    }

    public Credential setId(Long id) {
        this.id = id;
        return this;
    }

    public String getPwdHash() {
        return pwdHash;
    }

    public Credential setPwdHash(String pwdHash) {
        this.pwdHash = pwdHash;
        return this;
    }


    @Override
    public String toString() {
        return "Credential{" +
                "id=" + id +
                ", pwdHash='" + pwdHash + '\'' +
                '}';
    }
}
