//
//  SecondViewController.swift
//  Login
//
//  Created by Droadmin on 12/09/23.
//

import UIKit
import SQLite3
class SecondViewController: UIViewController {

    var db:OpaquePointer?
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var pswTxt: UITextField!
    @IBOutlet weak var userTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Registration"
        db = createDatabase()
        createTable()
        // Do any additional setup after loading the view.
    }
    

    @IBAction func regBtn(_ sender: Any) {
        insertData(userName: userTxt.text ?? "", password: pswTxt.text ?? "",name: nameTxt.text ?? "", email: emailTxt.text ?? "")
        self.navigationController?.popViewController(animated: true)

    }
    
    func createDatabase() -> OpaquePointer?{
       
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("Database.db")
            
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
               print("Database connection opened successfully \(fileURL)")
               return db
           } else {
               print("Failed to open database connection")
               return nil
           }
    }
    func createTable(){
        let tableQuery = "CREATE TABLE IF NOT EXISTS Regester(Id INTEGER PRIMARY KEY,name TEXT,email TEXT, username TEXT,password TEXT);"
        var statement: OpaquePointer? = nil
        //let database = createDatabase()
        if sqlite3_prepare_v2(db, tableQuery, -1, &statement, nil) == SQLITE_OK{
            if sqlite3_step(statement) == SQLITE_DONE{
                print("student table created")
            }else{
                print("student table not created")
            }
            sqlite3_finalize(statement)
        } else{
            print("could not prepared")
        }
   
    }
    func insertData(userName:String, password: String,name: String,email: String){
        let insertQuery = "INSERT INTO Regester(name,email,username,password)VALUES(?,?,?,?);"
        var statement: OpaquePointer?
        
        if sqlite3_prepare_v2(db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 2, (email as NSString).utf8String, -1, nil)

            sqlite3_bind_text(statement, 3, (userName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(statement, 4, (password as NSString).utf8String, -1, nil)


            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data inserted successfully.")
            } else {
                print("Failed to insert data into the database.")
            }
            
            let status = sqlite3_finalize(statement)
            print("Staus: \(status)")
        } else {
            print("Error preparing statement for insertion: \(String(cString: sqlite3_errmsg(db)))")
        }
    }

    

}
