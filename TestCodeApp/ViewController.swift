//
//  ViewController.swift
//  TestCodeApp
//
//  Created by Vijay Kunal on 09/05/23.
//

import UIKit

class ViewController: UIViewController {
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //getJsonData()
        let userObj = User()
        //userObj.registerUser()
        //userObj.getUserRequest()
        //userObj.registerUserWithEncodableProtocol()
        //userObj.getEmployeeDataUsingDecodableProtocol()
//        print(increaseIntValueByOne(number: 3))
//        print(increaseDoubleValueByOne(number: 3.0))
//        print(genericAdd(number: 6.0))
//
//        var stckObj = IntStack(items: [1, 2, 4])
//        print(stckObj.items)
//        print(stckObj.pop())
        
//        printElement("fdfdff")
//        printUsingWhereClause(456.77)
//        newPrintElement("werewrerfcs43")
      
        var reference1: Person?
        var reference2: Person?
        var reference3: Person?
        
        reference1 = Person(name: "Vijay")
        
        reference2 = reference1
        reference3 = reference1
        
        print(reference1)
        reference1 = nil
        reference2 = nil
        print(reference1)
        
    }
    
    
}

class Person {
    let name: String
    
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    
    deinit {
        print("\(name) is being de-initialized")
    }
}


func getJsonData() {
    let session = URLSession.shared
    let serviceUrl = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
    
    let task = session.dataTask(with: serviceUrl) { serviceData, serviceResponse, error in
        if error == nil {
            if let httpResponse = serviceResponse as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    do {
                        let jsonData = try JSONSerialization.jsonObject(with: serviceData ?? Data(), options: .mutableContainers)
                        print("Json data - \(jsonData)")
                        if let dic = jsonData as? [String: Any] {
                            print("Id - \(dic["id"] ?? 1)")
                            print("User Id - \(dic["userId"] ?? 0)")
                            print("Title - \(dic["title"] ?? "")")
                        }
                    } catch {
                        print("unable to parse json data")
                    }
                }
            }
        }
    }
    task.resume()
}

struct UserRegistrationRequest: Encodable {
    let email: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case password = "password"
    }
}

struct UserRegistrationResponse: Decodable {
    let id: Int
    let token: String
}

struct User {
    func registerUser() {
        // code to register user
        var urlRequest = URLRequest(url: URL(string: Endpoints.registerUser)!)
        urlRequest.httpMethod = "post"
        let dictData: [String: Any] = [
            "Id": 12345,
            "Customer": "John Smith",
            "Quantity": 1,
            "Price": 10.00
            
        ]
        do {
            let requestBody = try JSONSerialization.data(withJSONObject: dictData, options: .prettyPrinted)
            print(requestBody)
            urlRequest.httpBody = requestBody
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        } catch let error {
            debugPrint(error.localizedDescription)
        }
        URLSession.shared.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            if data != nil && data?.count != 0 {
                let response = String(data: data!, encoding: .utf8)
                debugPrint(response!)
            } else {
                debugPrint("unable to signup")
            }
        }.resume()
    }
    
    
    func registerUserWithEncodableProtocol() {
        var urlRequest = URLRequest(url: URL(string: Endpoints.registerEncodable)!)
        urlRequest.httpMethod = "post"
        let request = UserRegistrationRequest(email: "eve.holt@reqres.in", password: "pistol")
        
        do {
            let requestBody = try JSONEncoder().encode(request)
            debugPrint("request body before sending to post api - \(String(describing: String(data: requestBody, encoding: .utf8)))")
            urlRequest.httpBody = requestBody
            urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        } catch let error {
            print(error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            if data != nil && data!.count > 0 {
                let response = String(data: data!, encoding: .utf8)
                debugPrint("Api response - \(String(describing: response))")
                
                do {
                    let responseData = try JSONDecoder().decode(UserRegistrationResponse.self, from: data!)
                    print(responseData.id)
                    print(responseData.token)
                } catch let decodingError {
                    print(decodingError)
                }
                
                
            }
        }.resume()
    }
    
    
    func getUserRequest() {
        var urlRequest = URLRequest(url: URL(string: Endpoints.getUser)!)
        urlRequest.httpMethod = "get"
        
        URLSession.shared.dataTask(with: urlRequest) { data, httpUrlResponse, error in
            if data != nil && data?.count != 0 {
                let responseData = String(data: data!, encoding: .utf8)
                print("Response data - \(String(describing: responseData))")
            }
        }.resume()
    }
    
    // get employee data
    func getEmployeeDataUsingDecodableProtocol() {
        let employeeUrl =  URL(string: "https://mocki.io/v1/dca71a86-0fcc-43e0-a80f-7f46801bb0b5")//RL(string: "https://mocki.io/v1/35078035-e076-401c-9af9-c07b9b8f31a9")
        URLSession.shared.dataTask(with: employeeUrl!) { data, httpUrlResponse, error in
            if data != nil && data!.count != 0 && error == nil {
                let decoder = JSONDecoder()
                do {
                    let responseData = try decoder.decode([EmployeeResponse].self, from: data!)
                    
                    for didData in responseData {
                        print(didData.id)
                        print(didData.name)
                        print(didData.phone)
                        print(didData.depId)
                        print(didData.salary)
                        print(didData.joiningDate)
                        print(didData.role)
                    }
                    
                    
                } catch let decodingError {
                    print(decodingError)
                }
            }
        }.resume()
    }
}

struct EmployeeResponse: Decodable {
    let id, depId, phone: Int
    let name, role, joiningDate: String
    let salary: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case depId
        case phone
        case name
        case role
        case joiningDate
        case salary
    }
}

struct Endpoints {
    static let registerUser = "https://reqbin.com/echo/post/json"
    static let getUser = "https://jsonplaceholder.typicode.com/posts"
    static let registerEncodable = "https://reqres.in/api/register"
}

