//
//  SampleShowingAPIDataTableViewController.swift
//  TableViewWithAPI
//
//  Created by Jiwoong CHOI on 4/23/24.
//

import Alamofire
import SnapKit
import UIKit

class MainViewController: UITableViewController {
  // MARK: - Properties
  var BoredData: [BoredAPIModel] = []

  // MARK: - UI Components
  lazy var fetchNewDataButton: UIBarButtonItem = {
    let temp = UIBarButtonItem(
      image: UIImage(systemName: "arrow.down.circle.dotted"), style: .plain, target: self,
      action: #selector(fetchNewDataButtonTapped))
    return temp
  }()

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(APIDataTableCell.self, forCellReuseIdentifier: APIDataTableCell.identifier)
    tableView.backgroundColor = .systemBackground
    self.setupNavigation()

    fetchAPIData()
  }

  // MARK: - View Logics
  private func setupNavigation() {
    navigationItem.title = "Funny Things"
    navigationItem.largeTitleDisplayMode = .automatic
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.rightBarButtonItem = fetchNewDataButton
  }

  // MARK: - Button Actions
  @objc func fetchNewDataButtonTapped() {
    BoredData.removeAll()

    //     아래 여러 네트워크 통신 비동기 처리 코드 중 하나만 선택해서 사용할 것

    //     첫 번째 DispatchQueue와 DispatchGroup를 사용한 메소드
    //    fetchAPIData()

    //     두 번째 Callback을 사용하여 실시간 렌더링과 일괄 렌더링을 구현하는 메소드
    //     실시간 렌더링
    //     실시간 렌더링이라서 value의 무결성 검사를 하지 않는 점이 안정성의 미스라고 생각한다.
    //    fetchAPIDataRealtimeCallback { error in
    //      debugPrint(error ?? "This is error")
    //    }

    //     일괄 렌더링
    //     멀티 스레드에서 네트워크 작업을 하고 임시 변수에 받아둔 데이터를 메인스레드로 반환해 렌더링 작업을 마칩니다.
    fetchAPIDataOneQueueCallback { data, error in
      if let error = error {
        debugPrint(error)
      } else {
        self.BoredData = data!
        self.tableView.reloadData()
      }
    }

  }

  private func fetchAPIData() {
    let endPointURL = "https://www.boredapi.com/api/activity"
    let dispatchGroup = DispatchGroup()

    for _ in 0...29 {
      dispatchGroup.enter()
      AF.request(endPointURL, method: .get)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: BoredAPIModel.self) { response in
          switch response.result {
          case .success(let value):
            debugPrint(value.link)

            var mutableValue = value
            if mutableValue.link == "" {
              mutableValue.link = "Maybe there are no link!"
            }

            self.BoredData.append(mutableValue)

          case .failure(let error):
            print(error)
          }
          dispatchGroup.leave()
        }
    }

    dispatchGroup.notify(queue: .main) {
      self.tableView.reloadData()
    }
  }

  private func fetchAPIDataRealtimeCallback(completion: @escaping (Error?) -> Void) {
    let endPointURL = "https://www.boredapi.com/api/activity"

    for _ in 0...49 {
      AF.request(endPointURL, method: .get)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: BoredAPIModel.self) { response in
          switch response.result {
          case .success(let value):
            self.BoredData.append(value)
            DispatchQueue.main.async {
              self.tableView.reloadData()
            }
          case .failure(let error):
            completion(error)
          }
        }
    }
  }

  private func fetchAPIDataOneQueueCallback(
    completion: @escaping ([BoredAPIModel]?, Error?) -> Void
  ) {
    let endPointURL = "https://www.boredapi.com/api/activity"
    var tempAPIDATA = [BoredAPIModel]()
    let dispatchGroup = DispatchGroup()

    for _ in 0...49 {
      dispatchGroup.enter()
      AF.request(endPointURL, method: .get)
        .validate(statusCode: 200..<500)
        .responseDecodable(of: BoredAPIModel.self) { response in
          switch response.result {
          case .success(let value):
            tempAPIDATA.append(value)
          case .failure(let error):
            debugPrint(error)
            completion(nil, error)
          }
          dispatchGroup.leave()
        }
    }

    dispatchGroup.notify(queue: .main) {
      completion(tempAPIDATA, nil)
    }
  }

  // MARK: - Table view data source
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return BoredData.count
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
  {
    return 50
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
    -> UITableViewCell
  {
    guard
      let cell = tableView.dequeueReusableCell(
        withIdentifier: APIDataTableCell.identifier, for: indexPath) as? APIDataTableCell
    else { return APIDataTableCell() }

    // Configure the cell...
    cell.activityUILabel.text = "\(indexPath.row + 1). \(BoredData[indexPath.row].activity)"

    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let data = BoredData[indexPath.row]
    
    let detailViewController: DetailViewController = {
      let temp = DetailViewController()
      temp.activity.text = data.activity
      temp.type.text = "Type : \(data.type)"
      temp.participants.text = "Participant : \(data.participants))"
      temp.price.text = "Price : \(data.price))"
      temp.link.text = "Link : \(data.link)"
      temp.key.text = "Key : \(data.key)"
      temp.accesibility.text = "Accesibility : \(data.accessibility)"
      return temp
    }()

    navigationController?.pushViewController(detailViewController, animated: true)
  }
}