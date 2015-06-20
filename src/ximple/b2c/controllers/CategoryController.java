package ximple.b2c.controllers;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import ximple.b2c.beans.Category;
import ximple.b2c.dao.CatalogDao;

import static ximple.b2c.util.Log.log;

import java.util.*;

@Controller
@RequestMapping("/cat")
public class CategoryController {

    @RequestMapping(method = RequestMethod.GET)
    public String index(ModelMap model) {
        List<Category> allCategories = new ArrayList();
        List<Category> treeCategory = new ArrayList();
        try {
            allCategories = CatalogDao.getInstance().findCategories();

        }catch (Exception e){
            log.error(e);
        }
        int unparented = 0;
        for(Category currCat: allCategories){
            if(currCat.getParentId()==0){
                treeCategory.add(currCat);

            }else{
                Category parentCat = findCategoryByParentId(allCategories, currCat.getParentId());
                if(parentCat!= null) {
                    parentCat.getChildren().add(currCat);
                }else{
                    System.out.println("parentCat is null for "+currCat);
                    unparented++;
                }
            }
        }

        int count = 0;
        for(Category c: treeCategory){
            count +=counter(c);
        }
        System.out.println(count);

        //model.addAttribute("categories", allCategories );
        model.addAttribute("categories", treeCategory );

        return "cat";
    }

    private int counter(Category category){
        int count = 0;
        count++;
        if(category.getChildren().size()>0){
            for(Category ic: category.getChildren()){
                count += counter(ic);
            }
        }

        return count;
    }

    public Category findCategoryByParentId(List<Category> catList, int parentId){
        for(Category c: catList){
            if(c.getId() == parentId){
                return c;
            }
        }
        return null;
    }
}
