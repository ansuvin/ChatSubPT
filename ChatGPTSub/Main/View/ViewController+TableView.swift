//
//  ViewController+TableView.swift
//  ChatGPTSub
//
//  Created by 안수빈 on 2023/04/08.
//

import Foundation
import UIKit

import SnapKit

import RxSwift

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatStory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = chatStory[indexPath.row]
        
        switch data.role {
        case "user":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyCell.identifier, for: indexPath) as? MyCell else {
                return UITableViewCell()
            }
            
            cell.configCell(data)
            
            return cell
        case "assistant":
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AssistantCell.identifier, for: indexPath) as? AssistantCell else { return UITableViewCell()
            }
            
            cell.configCell(data)
            
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}

extension ViewController: UITableViewDelegate {
    
}
