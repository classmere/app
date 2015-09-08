//
//  CourseDetailViewController.swift
//  classmereApp
//
//  Created by Brandon Lee on 8/25/15.
//  Copyright (c) 2015 Brandon Lee. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CourseDetailViewController: UIViewController {

    @IBOutlet weak var abbrLabel: UILabel?
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var creditsLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    
    var detailCourse: Course? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let course: Course = self.detailCourse as Course! {
            println("Detail Item Course: " + course.abbr!)
            var abbr: String = course.abbr!
            
            APIService.getCourseByAbbr(abbr) { (data) -> Void in
                var courseWithSections = Course(courseJSON: data)
                
                // This is a test for grabbing general data from course
                println(courseWithSections.title!)
                
                // This is a test for grabbing data from a courses's section
                println("Section term: " + courseWithSections.sections[0].term!)
                
                self.title = courseWithSections.abbr!
                
                self.abbrLabel?.text = courseWithSections.abbr!
                self.titleLabel?.text = courseWithSections.title!
                //self.creditsLabel?.text = courseWithSections.credits!
                println(courseWithSections.credits)
                self.descriptionLabel?.text = courseWithSections.description!
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
