package ximple.b2c.beans;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by admin on 13.05.2015.
 */
public class Category {
    int id;
    int parentId;
    String name;
    String isActive;
    int level;
    boolean isLastLevel;

    List<Category> children = new ArrayList<Category>();

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getParentId() {
        return parentId;
    }

    public void setParentId(int parentId) {
        this.parentId = parentId;
    }

    public String isActive() {
        return isActive;
    }

    public void setActive(String isActive) {
        this.isActive = isActive;
    }

    public boolean isLastLevel() {
        return isLastLevel;
    }

    public void setLastLevel(boolean isLastLevel) {
        this.isLastLevel = isLastLevel;
    }

    public int getLevel() {
        return level;
    }

    public void setLevel(int level) {
        this.level = level;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }


    public List<Category> getChildren() {
        return children;
    }

    public void setChildren(List<Category> children) {
        this.children = children;
    }
}
