//
//  GravityController.swift
//  UIkitDynamicDemo
//
//  Created by HamGuy on 10/17/14.
//  Copyright (c) 2014 HamGuy. All rights reserved.
//

import UIKit

enum DynamicType:Int{
    case Gravity, Collisions , Springs, Snap, Focus, Properties
}

class GravityController: UIViewController,UICollisionBehaviorDelegate {

    
    
    @IBOutlet weak var ballView: UIImageView!
    @IBOutlet weak var wallView: UIView!

    var tagetType: DynamicType?
    
    var animator : UIDynamicAnimator!
    var snap : UISnapBehavior?
    var gravity : UIGravityBehavior?
    var pushbehavior : UIPushBehavior?
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var firstContact = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        // Do any additional setup after loading the view.
        self.animator = UIDynamicAnimator(referenceView: self.view)
    }
    
    override func viewWillAppear(animated: Bool) {
         self.title = titleforType(tagetType!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func ok(sender: AnyObject) {
        if ((gravity) != nil){
            animator.removeAllBehaviors()
        }
        
        gravity = UIGravityBehavior(items: [self.ballView])
//        gravity.setAngle(CGFloat(M_PI_2),magnitude: 0.2)
        self.animator?.addBehavior(gravity)
        
        switch tagetType!{
        case .Gravity:
            var collisionBehavior : UICollisionBehavior = UICollisionBehavior(items:[self.ballView])
            collisionBehavior.collisionDelegate=self
            collisionBehavior.translatesReferenceBoundsIntoBoundary = true
            self.animator?.addBehavior(collisionBehavior)
            break
        case .Collisions:
            var collisionBehavior : UICollisionBehavior = UICollisionBehavior(items:[self.ballView,self.wallView])
            collisionBehavior.collisionDelegate=self
            collisionBehavior.addBoundaryWithIdentifier("wallView", forPath: UIBezierPath(rect:self.wallView.frame))
            collisionBehavior.translatesReferenceBoundsIntoBoundary = true
            self.animator?.addBehavior(collisionBehavior)
            break
        case .Springs:
            wallView.hidden=true
            var collisionBehavior : UICollisionBehavior = UICollisionBehavior(items:[self.wallView])
            collisionBehavior.collisionMode = UICollisionBehaviorMode.Boundaries
            collisionBehavior.collisionDelegate=self
            collisionBehavior.addBoundaryWithIdentifier("wallView", forPath: UIBezierPath(rect:self.wallView.frame))
            collisionBehavior.translatesReferenceBoundsIntoBoundary = true
            self.animator?.addBehavior(collisionBehavior)
            
            let anchor = ballView.center
            var springsBehavior = UIAttachmentBehavior(item: ballView, attachedToAnchor: anchor)
            springsBehavior.frequency=1.0
            springsBehavior.damping=0.1
            springsBehavior.length=200
            
            animator.addBehavior(springsBehavior)
            break
        case .Snap:
            wallView.hidden = true
            break
        case .Focus:
                        break;
        case .Properties:
            var collisionBehavior : UICollisionBehavior = UICollisionBehavior(items:[self.ballView])
            collisionBehavior.translatesReferenceBoundsIntoBoundary = true
            self.animator?.addBehavior(collisionBehavior)
            
            var propertyBehavior = UIDynamicItemBehavior(items: [ballView])
            propertyBehavior.elasticity=1.0
            propertyBehavior.allowsRotation=false
            propertyBehavior.angularResistance=0.0
            propertyBehavior.density=3.0
            propertyBehavior.friction=0.5
            propertyBehavior.resistance=0.5
            
            animator!.addBehavior(propertyBehavior)
            
            break
        }
        let itemBehaviour = UIDynamicItemBehavior(items: [self.ballView])
        itemBehaviour.elasticity = 0.6
        self.animator?.addBehavior(itemBehaviour)
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, beganContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying, atPoint p: CGPoint) {
//        var updateCount = 0
//        behavior.action = {
//            if (updateCount % 3 == 0) {
//                let outline = UIView(frame: self.ballView.bounds)
//                outline.transform = self.ballView.transform
//                outline.center = self.ballView.center
//                
//                outline.alpha = 0.5
//                outline.backgroundColor = UIColor.clearColor()
//                outline.layer.borderColor = UIColor.greenColor().CGColor
//                outline.layer.borderWidth = 1.0
//                self.view.addSubview(outline)
//            }
//            
//            ++updateCount
//        }
    }
    
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if (tagetType! == DynamicType.Snap){
            if((snap) != nil){
                animator.removeBehavior(snap)
            }
            let touch = touches.anyObject() as UITouch
            snap = UISnapBehavior(item: ballView, snapToPoint: touch.locationInView(view))
            animator.addBehavior(snap)
        }
    }
    
    func titleforType(type:DynamicType)->String{
        switch type {
            // Use Internationalization, as appropriate.
        case .Gravity:
            wallView.hidden=true
            return "Gravity"
        case .Collisions:
            return "Collisions"
        case .Springs:
            self.wallView.hidden=true
            return "Springs"
        case .Snap:
            self.wallView.hidden=true
            return "Snap"
        case .Focus:
            self.wallView.hidden=true
            let gesture = UIPanGestureRecognizer(target:self, action:"panTheBall:")
            view.addGestureRecognizer(gesture)
            var collisionBehavior : UICollisionBehavior = UICollisionBehavior(items:[self.ballView])
            collisionBehavior.translatesReferenceBoundsIntoBoundary = true
            self.animator?.addBehavior(collisionBehavior)
            
            
            pushbehavior = UIPushBehavior(items: [ballView], mode: UIPushBehaviorMode.Instantaneous)
            pushbehavior!.angle = 0.0
            pushbehavior!.magnitude = 0.0
            animator!.addBehavior(pushbehavior!)

            return "Focus"
        case .Properties:
            wallView.hidden=true
            return "Properties"
        }
    }
    
    
    func panTheBall(gesture:UIGestureRecognizer){
        let point = gesture.locationInView(view)
        let origin = CGPoint(x: CGRectGetMidX(view.bounds), y: CGRectGetMidY(view.bounds))
        let tmp=powf(Float(point.x-origin.x),2)+powf(Float(point.y-origin.y),2)
        var distance=sqrtf(tmp)
        let angle = atan2(point.y-origin.y, point.x-origin.x)
        distance = min(distance, 100.0)
        pushbehavior!.magnitude=CGFloat(distance)/100.0
        pushbehavior!.angle=angle
        pushbehavior!.active=true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
