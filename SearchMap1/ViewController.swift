//
//  ViewController.swift
//  SearchMap1
//
//  Created by 赵晓东 on 16/5/13.
//  Copyright © 2016年 ZXD. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var Button_btn: UIButton!
    
    @IBOutlet weak var Button_Hotel: UIButton!

    @IBOutlet weak var Button_Hospital: UIButton!

    
    @IBOutlet weak var Button_SM: UIButton!
    
    //初始化位置
    let intiallLocation = CLLocationCoordinate2D.init(latitude: 39.9110130000, longitude: 116.4135540000)

    //设置搜索范围
    let searchRadius:CLLocationDistance = 4000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.createView()
        
        self.searchMap("place")
    }
    
    
    
    func createView() {

        //创建一个区域
        let region = MKCoordinateRegionMakeWithDistance(self.intiallLocation, self.searchRadius, self.searchRadius)
        //设置显示
        self.mapView.setRegion(region, animated: true)
        
        
        //加号
        self.Button_btn.alpha = 0
        self.Button_btn.addTarget(self, action: Selector("ButtonMenuClick"), forControlEvents: UIControlEvents.TouchUpInside)

        //对三个按钮的设置
        //酒店
        self.Button_Hotel.alpha = 0
        self.Button_Hotel.layer.cornerRadius = 10
        self.Button_Hotel.layer.masksToBounds = true
        self.Button_Hotel.titleLabel?.font = UIFont.systemFontOfSize(13)
        self.Button_Hotel.addTarget(self, action: Selector("ButtonHotelClick"), forControlEvents: UIControlEvents.TouchUpInside)
        //医院
        self.Button_Hospital.alpha = 0
        self.Button_Hospital.layer.cornerRadius = 10
        self.Button_Hospital.layer.masksToBounds = true
        self.Button_Hospital.titleLabel?.font = UIFont.systemFontOfSize(13)
        self.Button_Hospital.addTarget(self, action: Selector("ButtonHospitalClick"), forControlEvents: UIControlEvents.TouchUpInside)
        //超市
        self.Button_SM.alpha = 0
        self.Button_SM.layer.cornerRadius = 10
        self.Button_SM.layer.masksToBounds = true
        self.Button_SM.titleLabel?.font = UIFont.systemFontOfSize(13)
        self.Button_SM.addTarget(self, action: Selector("ButtonSMClick"), forControlEvents: UIControlEvents.TouchUpInside)
        
        UIView.animateWithDuration(1, delay: 1, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                //反转加号
                self.Button_btn.alpha = 1
                self.Button_btn.transform = CGAffineTransformMakeRotation(0.25*3.1415927)
            
            }, completion: nil)
        
        
    }
    
    //加号
    func ButtonMenuClick() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            
            //对三个按钮的设置
            self.Button_Hotel.alpha = 0.8
            self.Button_Hospital.alpha = 0.8
            self.Button_SM.alpha = 0.8
            
            self.Button_Hotel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.5, 1.5), CGAffineTransformMakeTranslation(-80, -25))
            
            self.Button_Hospital.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.5, 1.5), CGAffineTransformMakeTranslation(0, -50))
            
            self.Button_SM.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.5, 1.5), CGAffineTransformMakeTranslation(80, -25))
            
            
            //转加号
            self.Button_btn.transform = CGAffineTransformMakeRotation(0)
            
            }, completion: nil)
    }
    
    //酒店
    func ButtonHotelClick() {
        
        measure("hotel") {
            self.searchMap("hotel")
        }
        
        //恢复原位
        self.reset()
    }
    //医院
    func ButtonHospitalClick() {
        self.searchMap("hospital")
        
        //恢复原位
        self.reset()
    }
    //超市
    func ButtonSMClick() {
        self.searchMap("supermarket")
        
        //恢复原位
        self.reset()
    }
    
    
    
    
    //恢复原位
    func reset() {
    
        UIView.animateWithDuration(1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            
            //对三个按钮的设置
            self.Button_Hotel.alpha = 0
            self.Button_Hospital.alpha = 0
            self.Button_SM.alpha = 0
            
            self.Button_Hotel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(0, 0))
            
            self.Button_Hospital.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(0, 0))
            
            self.Button_SM.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1, 1), CGAffineTransformMakeTranslation(0, 0))
            
            
            //转加号
            self.Button_btn.transform = CGAffineTransformMakeRotation(0.25*3.1415927)
            
            }, completion: nil)
    }
    
    //增加兴趣地点
    func addLocation (title: String, latitude: CLLocationDegrees, longtitude: CLLocationDegrees) {
        let location = CLLocationCoordinate2DMake(latitude, longtitude)
        let annotation:MKAnnotation = MyAnnotation(coordinate: location, title: title)
        self.mapView.addAnnotation(annotation)
    }
    
    //搜索
    func searchMap (place: String) {
       
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = place
        //搜索当前区域
        let span = MKCoordinateSpanMake(0.1, 0.1)
        request.region = MKCoordinateRegionMake(self.intiallLocation, span)
        //启动搜索，并且把返回结果保存在数组中
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            if localSearchResponse != nil{
                for item in localSearchResponse!.mapItems {
                    self.addLocation(item.name!, latitude: (item.placemark.location?.coordinate.latitude)!, longtitude:(item.placemark.location?.coordinate.longitude)!)
                }
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

