package apijson.demo.model;

import apijson.framework.BaseModel;

import java.util.List;

public class Todo extends BaseModel {

    String title;
    String note;
    List<Long> helper;

    public String getTitle() {
        return title;
    }

    public Todo setTitle(String title) {
        this.title = title;
        return this;
    }

    public String getNote() {
        return note;
    }

    public Todo setNote(String note) {
        this.note = note;
        return this;
    }

    public List<Long> getHelper() {
        return helper;
    }

    public Todo setHelper(List<Long> helper) {
        this.helper = helper;
        return this;
    }
}
