//
//  AQMDataProvider.swift
//  AirQualityMonitoring
//
//  Created by Ramkrishna Sharma on 22/12/21.
//

//** AQMDataProvider view model class does is :**
//1. Establish websocket connection
//2. Handle data
//3. Inform respective implementer for data updation

import Foundation
import Starscream

protocol AQMDataProviderDelegate {
    //Did recieve response from API call
    func didReceive(response: Result<[AQMResponseData], Error>)
}

class AQMDataProvider {
    //Is websocket connected
    var isConnected: Bool = false

    //API response delegate
    var delegate: AQMDataProviderDelegate?

    //Websocket instance
    var socket: WebSocket? = {
        //URL
        guard let url = URL(string: ServerConnection.url) else {
            print("can not create URL from: \(ServerConnection.url)")
            return nil
        }
        //Request based on URL
        var request = URLRequest(url: url)
        //timeout interval of the receiver.
        request.timeoutInterval = 5
        //Create websocket instance
        var socket = WebSocket(request: request)
        return socket
    }()

    //Subcribe to websocket connection
    func subscribe() {
        //Set delegate itself
        self.socket?.delegate = self
        //Connect to websocket
        self.socket?.connect()
    }

    //Unsubcribe to websocket connection
    func unsubscribe() {
        //Disconnect to websocket
        self.socket?.disconnect()
    }

    //Life cycle method
    deinit {
        //Disconnect websocket connection
        self.socket?.disconnect()
        //For memory release purpose only
        self.socket = nil
    }
}

//Websocket delegate
extension AQMDataProvider: WebSocketDelegate {
    //Asynchronous response from websocket based on its status
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
            //Connected
            case .connected(let headers):
                //Set connected value true
                isConnected = true
                print("websocket is connected: \(headers)")
            //Disconnected
            case .disconnected(let reason, let code):
                //Set connected value false
                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            //Recieved text data
            case .text(let string):
                handleText(text: string)
            //Cancelled
            case .cancelled:
                //Set connected value false
                isConnected = false
            //Recieved error
            case .error(let error):
                //Set connected value false
                isConnected = false
                //Handle error
                handleError(error: error)
            //For all other websocket status
            default:
                break

        }
    }

    //Handle text reponse from websocket's delegate method didReceive()
    private func handleText(text: String) {
        let jsonData = Data(text.utf8)
        let decoder = JSONDecoder()
        do {
            //Decode data
            let resArray = try decoder.decode([AQMResponseData].self, from: jsonData)
            //Inform delegate implemenator that new data has arrived
            self.delegate?.didReceive(response: .success(resArray))
        } catch {
            print(error.localizedDescription)
        }
    }

    //Handle error from websocket's delegate method didReceive()
    private func handleError(error: Error?) {
        if let e = error {
            self.delegate?.didReceive(response: .failure(e))
        }
    }
}

