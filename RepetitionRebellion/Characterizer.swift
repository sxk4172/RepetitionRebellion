//
//  Characterizer.swift
//  Repetition Rebellion
//
//  Created by Stephen Jacobs on 12/19/15.
//  Copyright © 2015 Repetition Rebellion. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class Characterizer: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    //an array of the buttons used to select what type of Imp is desired
    var typeButtons = [UIButton]()
    //An array that links a given button to a part of the Imp, used on all part buttons - ideally, we would replace it after implementing more of the collectionview's selection methods
    var buttonData = [UIButton:PartInfo]()
    //The collectionviews need to know which file numbers exist, so we traverse the file structure and add those numbers to this array
    var imageNumberByPart = [String:[String:[Int]]]()
    //Tracks which scroller holds which part's options
    var collectionViewData = [UICollectionView:PartInfo]()
    //Holds the views on each page of the characterizer so they can be removed and replaced - hopefully replaced by a UITabView later
    var pages = [[UIView]]()
    var currentPage = 0
    var imp = Imp(kind:"human")
    var colorPicker = ColorPicker()
    var typeImage = [UIImageView]()
    
    //When the characterizer returns to the type selection screen, (currently disabled) it hides your current work, and reveals it again if you select the same type as before. Otherwise, it restarts the process with the new type.
    var imp_hidden = false
    //This holds everything that should be removed during the return to type selection.
    var hideable = [UIView]()
    
    //After the view loads, set up the four options for body types
    override func viewDidLoad() {
        print("Characterizer")
        //hide the navigation bar
       // self.navigationController!.navigationBarHidden = true
        
        super.viewDidLoad()
        showTypeSelectionScreen()
    }
    
    // This is the first state the characterizer is in, before displaying all of the scrollers and other imp creation views.
    // It displays a button for each different 'type' or 'kind' of Imp.
    func showTypeSelectionScreen() {
        //Make each button the size of a third of the screen
        let type_w = screen_width/3
        let type_h = screen_height/3
        
        //The buttons currently use hard-coded links to preliminary art, and also do not use any screen scaling or anchors
        //The title is not visible, but we retrieve it when the button is clicked, and pass it as the 'kind' of the imp.
        

        
        
        let im = UIImage(named: "icons/Text.png")
      //  let pick_typ = UIImageView(frame: CGRectMake(50, 70, screen_width-100, 50))
        let pick_typ = UIImageView(frame: CGRect(x: 50, y: 70, width: screen_width-100, height: 50))
        pick_typ.image = im
        view.addSubview(pick_typ)
        typeImage.append(pick_typ)
        
        let himage = UIImage(named: "icons/RobotBody.png")
        let hbutton = addButton(image: himage!, function: #selector(Characterizer.typeChosen(sender:)), x: 30, y: 150, width: type_w, height: type_h-80, view: self.view)
        hbutton.setTitle("human", for: .normal)
        typeButtons.append(hbutton)
        
        let wimage = UIImage(named: "icons/WerewolfBody.png")
        let wbutton = addButton(image: wimage!, function: #selector(Characterizer.typeChosen(sender:)), x: 80+type_w, y: 150, width: type_w, height: type_h-80, view: self.view)
        wbutton.setTitle("goblin", for: .normal)
        typeButtons.append(wbutton)
        
        let kimage = UIImage(named: "icons/HumanBody.png")
        let kbutton = addButton(image: kimage!, function: #selector(Characterizer.typeChosen(sender:)), x: type_w, y: 80 + type_h, width: type_w - 30, height: type_h-80, view: self.view)
        kbutton.setTitle("goblin", for: .normal)
        typeButtons.append(kbutton)
        
        
        let aimage = UIImage(named: "icons/AmoebaBody.png")
        let abutton = addButton(image: aimage!, function: #selector(Characterizer.typeChosen(sender:)), x: 30, y: ((screen_height/2) + 130), width: type_w, height: 125, view: self.view)
        print("type_h : \(type_h)")
        abutton.setTitle("amoeba", for: .normal)
        typeButtons.append(abutton)
        
        
        let bimage = UIImage(named: "icons/GooBody.png")
        let bbutton = addButton(image: bimage!, function: #selector(Characterizer.typeChosen(sender:)), x: 80+type_w, y: ((screen_height/2) + 80), width: type_w, height: type_h, view: self.view)
        bbutton.setTitle("blob", for: .normal)
        typeButtons.append(bbutton)
    }
    
    
    //After the type is chosen, set up the options for each individual type
    func typeChosen(sender:UIButton) {
        //Get the title we set earlier for each button
        imp = Imp(kind: sender.currentTitle!)
        
        //Remove all type buttons from the screen
        for button in typeButtons{
            button.removeFromSuperview()
        }
        for button in typeImage{
            button.removeFromSuperview()
        }
        typeImage.removeAll()
        typeButtons.removeAll() //clear the typebutton list - it is not used again unless it is refilled for 'going back to the type selection'
        
        
        
        //Create the imp and the pages of characterizer options, including save/load/other buttons
        imp.setup(view: self)
        
        createPages()
    }
    //Creates an image button
    func addButton(image: UIImage, function: Selector, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, view : UIView) -> UIButton{

        let button   = UIButton(type:UIButtonType.custom)
        button.frame = CGRect(x: x, y: y, width: width, height: height)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: function, for:.touchUpInside)
        view.addSubview(button)
        return button
    }
    
    //a button for each part choice - several of these are generated by each scroller
    func addPartButton(part:PartInfo, x: CGFloat, y: CGFloat, view :UIView) -> Bool{
        
        var image = UIImage(named: "parts/"+part.category+"-"+part.subtype+"/char-pieces-"+String(part.index)+"-thumb")
        if image == nil {return false}
        image = image!.imageWithColor(color1: imp.currentColors[part.category]![part.subtype]!, mode: .multiply)
        
        let button = addButton(image: image!, function: #selector(Characterizer.partSelected(sender:)), x: x, y: y, width: view.frame.width, height: view.frame.height, view: view)
        
        //if it is currently selected, highlight the background. Highlighting the border might work better later
        if imp.currentParts[part.category]![part.subtype]! == part.index{
            button.backgroundColor = UIColor(red: 1.36, green: 0.78, blue: 1.60, alpha: 0.2)
            imp.currentButtons[part.category]![part.subtype] = button
        }
        else {
            button.backgroundColor = UIColor(red: 1.36, green: 0.78, blue: 1.60, alpha: 0.2)
        }
        
        buttonData[button] = part
        button.draw(CGRect(x: 0, y: 500, width: 100, height: 100))

        return true
    }
    
    //Used when an option inside a scrollview selects a part to change
    func partSelected(sender:UIButton){
        let bd = buttonData[sender]!
        
        //get the currently highlighted button
        let button = imp.currentButtons[bd.category]![bd.subtype]!
        
        //return its background color to normal
        button.backgroundColor = UIColor(red: 1.36, green: 0.78, blue: 1.60, alpha: 0.2)
        
        //update the imp data with the new selected index and button
        imp.partSelected(part: bd, button: sender, view: self)
        sender.backgroundColor = UIColor(red: 1.36, green: 0.78, blue: 1.60, alpha: 0.5)
    }
    
    //generates the information the UICollectionViewDataSource needs, from the files in the appropriate resource folder
    // It takes the category and subtype and uses them to find the necessary folders.
    // yOffset and Size inform the visual attributes of the created CollectionView and buttons.
    func createButtonScroller(category: String, subtype: String, yOffset:Int, size:CGFloat)-> UIScrollView{
        
        //If the containing dictionary does not already exist, create it so that the subtype dict does not crash
        if imageNumberByPart[category] == nil { imageNumberByPart[category] = [String:[Int]]()}
        
        imageNumberByPart[category]![subtype] = [Int]() //initialize dictionary for this part subtype
        
        let fileManager = FileManager.default
        
        let base_folder = Bundle.main.bundlePath
        let path = base_folder+"/parts/"+category+"-"+subtype
        //print (path)
        //print ( fileManager.fileExistsAtPath(path))
        
        //The enumerator will let us easily loop through all of the files in the folder
        let enumerator:FileManager.DirectoryEnumerator = fileManager.enumerator(atPath: path)!

        var successfulButtons = 0 //keep track of how many buttons are in the list
        while let element = enumerator.nextObject() as? String {
            if element.hasSuffix("png") && element.contains("thumb") { // checks the extension and if it is a thumb
                //(We only need thumbnails to make the scrollers)
                let regex = try! NSRegularExpression(pattern: "[0-9]+", //get the numbers in the filename
                                                     options: [.caseInsensitive])
                
                let match = regex.firstMatch(in: element, options:[], range: NSMakeRange(0, element.utf16.count))
                //Get the location of the match
                let range = match?.range
                print("range : \(range) \(element)")
                if (range != nil ) { //if it has a number
                
                    //Convert the NSIndex indices to Index indices
                   // let startIndex = element.startIndex.advancedBy((range?.location)!)
                    let startIndex = element.index(element.startIndex, offsetBy: (range?.location)!)
                    let endIndex = element.index(startIndex, offsetBy :(range?.length)!)

                    print(startIndex)
                    print(endIndex)
                    //Use them to create a Range from the NSRange indices
                   // i = Int( element.substringWithRange(Range(startIndex ..< endIndex)) )!
                    i = Int( element.substring(with: Range(startIndex ..< endIndex)))!
                    //print(i)
                
                    //Note down the successful number and increment the count of buttons
                    imageNumberByPart[category]![subtype]?.append(i)
                    
                    successfulButtons += 1
                    
                }
            }
        }
        print ("success buttons :  \(successfulButtons)")
        
        //Define the layout and looks of the scroller - perhaps could be made once and reused
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: size, height: size)
        layout.scrollDirection = .horizontal
        //Create the CollectionView
        let collectionView = UICollectionView(frame:CGRect(x: 10, y: 50+yOffset, width: Int(screen_width-80), height: Int(size)), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        
        collectionViewData[collectionView] = PartInfo(category: category, subtype: subtype, index: 0)//note which part it affects
        
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")

        collectionView.alwaysBounceHorizontal = true
        
        
        return collectionView
    }
    
    //Get the button count for a given section of a given collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let category = collectionViewData[collectionView]!.category
        let subtype = collectionViewData[collectionView]!.subtype
        return imageNumberByPart[category]![subtype]!.count
    }
    
    //Get the cell at the given index of the given collectionview
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        let category = collectionViewData[collectionView]!.category
        let subtype = collectionViewData[collectionView]!.subtype
        

        
        addPartButton(part: PartInfo(category: category, subtype: subtype, index: imageNumberByPart[category]![subtype]![indexPath.item]), x:0, y: 0, view: cell.contentView)
        
        

        return cell
    }
    
    // Create the pages that separate out the different part options in the characterizer, as well as other auxiliary buttons
    func createPages(){
        print("create")
        
        //clear any older buttons
        buttonData.removeAll()
        //sizing notes
        let offset = 40
        let partsize = 80 * g_ratio
        
        //get the desired number of pages for this kind of imp
        let max = imp.pages[imp.kind]!.count
        //define the width of each button on the top bar that shows the page names (and type selection, if enabled)
        //when switching to tabview, this will be moved down and no longer manual
        //let topbar_button_width = screen_width/CGFloat(max+1)//add 1 for the "type" button
        
        //the names of the pages are defined in the imp itself
        for (i, page) in imp.pages[imp.kind]!.enumerated(){
            pages.append([UIView]())
            
            let pick_image = UIImage(named: "icons/Eyes_Mouth_Instructions.png")
          //  let pick_button = UIImageView(frame: CGRectMake(10, displayheight + CGFloat(offset), (screen_width-80), partsize/2))
            let pick_button = UIImageView(frame: CGRect(x: 10, y: displayheight + CGFloat(offset), width: (screen_width-80), height: partsize/2))
            pick_button.image = pick_image
            
//            //add the text label to say which page you are on
//            let label = UITextView(frame: CGRectMake(CGFloat((screen_width-140)/2), displayheight + CGFloat(offset), 140, partsize/2))
//            label.text = page.name
//            label.editable = false
//            label.font = UIFont.systemFontOfSize(20*g_ratio)
//            label.textAlignment = NSTextAlignment.Center
//            label.hidden = true
            
            pages[pages.count-1].append(pick_button)
            
//            //create the buttons for the top bar
//            let topbar = UIButton(frame: CGRectMake(CGFloat(i+1)*topbar_button_width, 0, topbar_button_width, partsize))
//            topbar.setTitle(page.name, forState: .Normal)
//            topbar.tag = i
//            topbar.addTarget(self, action: #selector(Characterizer.switchPageByTag(_:)),forControlEvents: .TouchUpInside)
//            view.addSubview(topbar)
        }
        // The disabled 'return to type selection' button
        //let typeButton = UIButton(frame: CGRectMake(0, 0, topbar_button_width, partsize))
        //typeButton.setTitle("type", forState: .Normal)
        //typeButton.addTarget(self, action: "returnToTypeSelection:", forControlEvents: .TouchUpInside)
        //view.addSubview(typeButton)
        
        // go through every subtype the imp's kind has
        for typ in imp.types[imp.kind]!{
            for subtype in imp.parts[typ]!{
                
                let btn_height = partsize*1.2
                
                //locate the page its scroller belongs on
                let (page_idx, vert_idx) = imp.findInPage(goal: subtype)
                
                //create the scroller
                let scv = createButtonScroller(category: typ, subtype: subtype,
                    yOffset: Int(displayheight)+offset+(vert_idx)*Int(btn_height)+10, size:partsize)
                
                //create the recolor button
                var im = UIImage(named: "icons/paint_brush_new.png")
                im = im!.imageWithColor(color1: imp.currentColors[typ]![subtype]!, mode: .multiply)
                
                let cb = addButton(image: im!, function: #selector(Characterizer.recolor(sender:)), x:screen_width - buttonsize, y:displayheight+(CGFloat(offset)+CGFloat(vert_idx)*btn_height+(partsize))-10, width:buttonsize, height:buttonsize, view:self.view)
                cb.setTitle("color", for: .normal)
                
                //set the data for the button: which part it applies to, and a color index
                let part = PartInfo(category:typ, subtype:subtype, index:3)
                buttonData[cb] = part
                
                //Add them to the appropriate page
                pages[page_idx].append(scv)
                pages[page_idx].append(cb)
            }
        }
        
        //set up the currently visible scrollers (The others don't need to be added to the view until later)
        for sview in pages[currentPage] {
            self.view.addSubview(sview)
        }
        
        //Add the 'next' button, if necessary
        if pages.count>1{
            let img = UIImage(named: "icons/NextArrowNew.png")
            let nb = addButton(image: img!, function: #selector(Characterizer.nextPage(sender:)), x:screen_width-buttonsize, y:displayheight+CGFloat(-10+offset), width:buttonsize, height:buttonsize, view:self.view)
            nb.setTitle("next", for: .normal)
            hideable.append(nb)
            
        }
        

        
        //The base/skin recolor button
        var im = UIImage(named: "icons/paint_brush_new.png")
        im = im!.imageWithColor(color1: imp.currentColors[imp.kind]!["base"]!, mode: .multiply)
        
        let cb = addButton(image: im!, function: #selector(Characterizer.recolor(sender:)), x:displaywidth+10, y:100, width:buttonsize, height:buttonsize, view:self.view)
        cb.setTitle("color", for: .normal)
        buttonData[cb] = PartInfo(category:imp.kind, subtype:"base", index: 0)
        hideable.append(cb)
        
        //The save button
        im = UIImage(named: "icons/SaveNew.png")
        let sb = addButton(image: im!, function: #selector(Characterizer.save(sender:)), x:screen_width-buttonsize, y:100, width:buttonsize, height:buttonsize, view:self.view)
        sb.setTitle("save", for: .normal)
        hideable.append(sb)
        
        //The load button
        im = UIImage(named: "icons/Load_FolderNew.png")
        let lb = addButton(image: im!, function: #selector(self.load), x:screen_width-buttonsize, y:100+buttonsize, width:buttonsize, height:buttonsize, view:self.view)
        lb.setTitle("load", for: .normal)
        hideable.append(lb)
    
        
        //The exit button
        im = UIImage(named: "icons/Back_ArrowNew.png")
       // let exit_button = UIButton(frame: CGRectMake(screen_width-buttonsize, 100+buttonsize*2, CGFloat(buttonsize), CGFloat(buttonsize)))
        let exit_button = UIButton(frame: CGRect(x: screen_width-buttonsize, y: 100+buttonsize*2, width: CGFloat(buttonsize), height: CGFloat(buttonsize)))
        exit_button.setImage(im, for: .normal)
        exit_button.addTarget(self, action: #selector(Characterizer.exit(sender:)),for: .touchUpInside)
        view.addSubview(exit_button)
        
        
//        im = UIImage(named: "icons/Color_Swatches.png")
//        let color_swatch = UIImageView(frame: CGRectMake(10, screen_height-50, screen_width-20, 50))
//        color_swatch.image = im
//        self.view.addSubview(color_swatch)
        
        //Make all parts of the imp hideable for return to type selection
        for category in imp.currentImageViews.keys{
            for subtype in imp.currentImageViews[category]!.keys{
                hideable.append(imp.currentImageViews[category]![subtype]!)
            }
        }
        
    }
    func nextPage(sender:UIButton){
        switchPage(targetPage: (currentPage+1)%pages.count)//loops
    }
    //The page buttons all have their page number attached as a 'tag'
    //when they are clicked this method handles switching to that page.
    func switchPageByTag(sender:UIButton){
        switchPage(targetPage: sender.tag)
    }
    //When the exit button is clicked
    func exit(sender: UIButton){
        
        //unhide the navigation bar
        //self.navigationController!.isNavigationBarHidden = false
        
        //Original exit code
        //removes the current viewcontroller in a way intended to resemble the 'back' button on the navigation bar.
       // self.navigationController!.popViewControllerAnimated(true)
        
        //Goes back to the main menu via a segue set up in the storyboard
       // self.performSegue(withIdentifier: SEGUE_Main, sender: nil)
        print("back pressed")
        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
        self.present(viewController, animated: false, completion: nil)
    }
    //take all of the scrollers from one page out of the view, and replace them with the next
    func switchPage(targetPage: Int){
        unhidePages()
        
        for view in pages[currentPage] {
            
            view.removeFromSuperview()
        }
        
        for view in pages[targetPage] {
            
            self.view.addSubview(view)
        }
        
        currentPage = targetPage
        
    }
    //### return to type selection
    
    func hidePages(){
        for view in hideable{
            view.removeFromSuperview()
        }
        
        for view in pages[currentPage] {
            
            view.removeFromSuperview()
        }

        imp_hidden = true
    }
    func unhidePages(){
        if imp_hidden{
            for view in hideable{
                self.view.addSubview(view)
            }
            
            for view in pages[currentPage] {
                
                self.view.addSubview(view)
            }
            imp_hidden = false
        }
    }
    
    // called on hit to 'type' button in page list, hides characterizer and reshows type page
    func returnToTypeSelection(sender: UIButton){
        //hide all page content and characterizer displays
        //do not hide top bar
        hidePages()
        
        //restore content when top bar buttons are hit (code in switchPage)
        
        //show type selection buttons
        //when existing type button is hit, go to first page without resetting
        //otherwise, setup new imp
    }
    
    //called when we need to launch a color picker
    func recolor(sender:UIButton){
        let bd = buttonData[sender]!
        colorPicker.colorPicker(category: bd.category, subtype: bd.subtype, characterizer:self)
    }

    //called when a color is selected in the ColorPicker
    func colorPicked(info:PartInfo){
        print("colorPicked")
        //Set the color of the specified part to the color at the index that was picked
        imp.currentColors[info.category]![info.subtype]! = colors[info.index]
        
        //refresh the drawing of the part that has been recolored
        if info.subtype == "base"{
            imp.baseRecolor(view: self)
            print("if")
        }
        else {
            print("else")
            imp.partSelected(part: PartInfo(category:info.category, subtype:info.subtype,
                index:imp.currentParts[info.category]![info.subtype]!), button: imp.currentButtons[info.category]![info.subtype]!, view: self)
        }
        
        //refresh the drawing of the buttons (each button in a scroller is colored to match its part's current selected color)
        for button in buttonData.keys {
            //go through all of the buttons and only work with those of the right subtype
            //it may be possible to go through the collectionview instead
            let data = buttonData[button]!
            if data.subtype == info.subtype {
                var image:UIImage? = nil
                
                if button.currentTitle == "color" {//this button is the recolor button
                    image = UIImage(named: "icons/paint_brush_new.png")
                }
                else{//other buttons are all part buttons
                    image = UIImage(named: "parts/"+data.category+"-"+data.subtype+"/char-pieces-"+String(data.index)+"-thumb")
                }
                // in case there is no image of this name
                if image == nil {continue}
                
                //change the image
                print("\(imp.currentColors[data.category]![data.subtype]!) : \(data.category) : \(data.subtype)")
                image = image!.imageWithColor(color1: imp.currentColors[data.category]![data.subtype]!, mode: .multiply)
                
                button.setImage(image, for: .normal)
            }
        }
        
    }

    
    
//##############################    save/load    ##########################
    
    //create a new object of the type named in entityName - types are defined in DataModel.xcdatamodeld
    func newSaveObject(entityName: String, appDel: AppDelegate) -> NSManagedObject {
        
        return NSEntityDescription.insertNewObject(forEntityName: entityName,
                                                   into: context)
    }
    
    func save(sender : UIButton){
        
        
        let alert = UIAlertController(title: "Save",
                                      message: "Are you Sure?",preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default, handler: { (action:UIAlertAction) -> Void in
                                        
            
                                        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
                                        //currentparts, currentcolors, kind
                                        //delete old imps to prevent memory crash on load
                                        let imps = self.loadEntityFromName(entityName: "Imp", appDel: appDel)
                                        for imp in imps {
                                            context.delete(imp as! NSManagedObject)
                                            print("deleted")
                                        }
                                        let parts = self.loadEntityFromName(entityName: "Part", appDel: appDel)
                                        for part in parts {
                                            context.delete(part as! NSManagedObject)
                                            print("deleted")
                                        }
                                        
                                        let partsel = self.loadEntityFromName(entityName: "PartSelected", appDel: appDel)
                                        for part in partsel {
                                            context.delete(part as! NSManagedObject)
                                            print("deleted")
                                        }
                                        let colors = self.loadEntityFromName(entityName: "Color", appDel: appDel)
                                        for part in colors {
                                            context.delete(part as! NSManagedObject)
                                            print("deleted")
                                        }
                                        
                                        
                                        do {
                                            try context.save()
                                            
                                        } catch {
                                            print("Unresolved error - could not delete table")
                                            abort()
                                        }
                                        
                                        //save new imp
                                        let imp_data = self.newSaveObject(entityName: "Imp", appDel: appDel)
                                        
                                        //save the kind of imp selected
                                        imp_data.setValue(self.imp.kind, forKey: "kind")
                                        
                                        //save the part and color selected for each option type
                                        for category in self.imp.types[self.imp.kind]!{
                                            for subtype in self.imp.parts[category]!{
                                                let part_data = self.newSaveObject(entityName: "Part", appDel: appDel)
                                                part_data.setValue(category, forKey: "category")
                                                part_data.setValue(subtype, forKey: "subtype")
                                                
                                                let color_data = self.newSaveObject(entityName: "Color", appDel: appDel)
                                                let selected_data = self.newSaveObject(entityName: "PartSelected", appDel: appDel)
                                                
                                                //get the rgb value of the current color
                                                var r:CGFloat = 0
                                                var g:CGFloat = 0
                                                var b:CGFloat = 0
                                                var a:CGFloat = 0
                                                self.imp.currentColors[category]![subtype]!.getRed(&r, green: &g, blue: &b, alpha: &a)
                                                
                                                color_data.setValue(r, forKey: "r")
                                                color_data.setValue(g, forKey: "g")
                                                color_data.setValue(b, forKey: "b")
                                                color_data.setValue(imp_data, forKey: "imp")
                                                color_data.setValue(part_data, forKey: "part")
                                                
                                                
                                                selected_data.setValue(self.imp.currentParts[category]![subtype]!, forKey: "index")
                                                selected_data.setValue(imp_data, forKey: "imp")
                                                selected_data.setValue(part_data, forKey: "part")
                                                
                                            }
                                        }
                                        //save base color
                                        let part_data = self.newSaveObject(entityName: "Part", appDel: appDel)
                                        part_data.setValue(self.imp.kind, forKey: "category")
                                        part_data.setValue("base", forKey: "subtype")
                                        
                                        let color_data = self.newSaveObject(entityName: "Color", appDel: appDel)
                                        
                                        //get the rgb value of the current color
                                        var r:CGFloat = 0, g:CGFloat = 0, b:CGFloat = 0, a:CGFloat = 0
                                        self.imp.currentColors[self.imp.kind]!["base"]!.getRed(&r, green: &g, blue: &b, alpha: &a)
                                        
                                        color_data.setValue(r, forKey: "r")
                                        color_data.setValue(g, forKey: "g")
                                        color_data.setValue(b, forKey: "b")
                                        color_data.setValue(imp_data, forKey: "imp")
                                        color_data.setValue(part_data, forKey: "part")
                                        
                                        //save a binary image to be used elsewhere in the app
                                        let imgData = UIImagePNGRepresentation(self.imp.getImage())
                                        imp_data.setValue(imgData, forKey: "image")
                                        
                                        //save
                                        do {
                                            try context.save()
                                            
                                        } catch {
                                            print("Unresolved error - could not save")
                                            abort()
                                        }
                    
                                    UIGraphicsBeginImageContextWithOptions(CGSize(width: 102 , height: 100) , false, 0)
                                        
                                        self.view.drawHierarchy(in: CGRect(x: 0, y: 0, width: 180, height: 250), afterScreenUpdates: true)
                                        
                                        let imageSaved:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                                        
                                        UIGraphicsEndImageContext()
                                        
                                        
                                        UserDefaults.standard.set(UIImagePNGRepresentation(imageSaved), forKey: "loadImage")

                                        
                                        print("back pressed")
                                        let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
                                        self.present(viewController, animated: false, completion: nil)
                                        
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action: UIAlertAction) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    
    }
    func load() {
        
        let appDel: AppDelegate = (UIApplication.shared.delegate as! AppDelegate)
        
        
        let imps = loadEntityFromName(entityName: "Imp", appDel: appDel)
        //for item_ in imps{
        //
        //    let item = item_ as! NSManagedObject
        //    print(item)
        //} //test print of every saved imp
        
        //if there is any saved data
        if imps.count>0 {
        
            //clear the button list in preparation to start over
            for button in buttonData.keys{
                button.removeFromSuperview()
                buttonData[button]=nil
            }
            buttonData.removeAll()
            pages.removeAll()
            imp.destroy()
        
            //load the most recent imp
            let imp_data = imps[imps.count-1]
            //imp = Imp(kind: imp_data.value("kind")! as! String)
            imp = Imp(kind: imp_data.value(forKey: "kind") as! String)
            
            imp.setup(view: self) //create the initial imp of the right kind
            
            //set all of the loaded colors
            for color in imp_data.value(forKey:"color")! as! Set<NSManagedObject>{
                let part = color.value(forKey: "part")!
                imp.currentColors[(part as AnyObject).value(forKey:"category")! as! String]![(part as AnyObject).value(forKey:"subtype")! as! String]
                    = UIColor(red:color.value(forKey: "r")! as! CGFloat,
                            green:color.value(forKey: "g")! as! CGFloat,
                            blue:color.value(forKey: "b")! as! CGFloat, alpha:1)
                if (part as AnyObject).value(forKey:"subtype")! as! String == "base"{
                    imp.baseRecolor(view: self)
                }
            }

            //set all of the loaded part selections
            for part_s in imp_data.value(forKey:"partSelected")! as! Set<NSManagedObject>{
                let part = part_s.value(forKey: "part")!
                imp.partSelected(part: PartInfo(category: (part as AnyObject).value(forKey:"category")! as! String,
                                        subtype: (part as AnyObject).value(forKey:"subtype")! as! String,
                    index: part_s.value(forKey:"index")! as! Int), button: UIButton(), view: self)
            }
        
            //put up the UI
            createPages()
            
            // Display the test image
            
            //let imgData = imp_data.valueForKey("image")! as! NSData
            //let image = UIImageView(image: UIImage(data: imgData))
            //image.frame = CGRect(x: 0, y: 0, width: screen_width, height: screen_height)
            //view.addSubview(image)
            
        }
        //otherwise ignore the request

    }
    
    //Loads an entity from the database
    func loadEntityFromName(entityName:String, appDel: AppDelegate) -> [AnyObject] {
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try context.fetch(fetchRequest)
            return result as [AnyObject]
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()

    }
    
    
}

