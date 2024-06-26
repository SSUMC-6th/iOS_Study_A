//
//  GoogleAuthViewController.swift
//  Week4_Mission
//
//  Created by Jiwoong CHOI on 5/12/24.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import SnapKit
import SwiftUI
import UIKit

class GoogleAuthViewController: UIViewController {

  // MARK: - Life Cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    self.setupViews()
    self.setupViewsLayout()

    googleAuthButton.addTarget(
      self, action: #selector(makeUserAuthenticationInfo), for: .touchUpInside)
  }

  // MARK: - UI Components Properties
  let googleAuthButton: UIButton = {
    let button = UIButton()
    button.backgroundColor = .white
    button.setTitle("Google Log-In", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.layer.cornerRadius = 5
    button.layer.borderWidth = 1
    return button
  }()

  // MARK: - View Contraints
  private func setupViews() {
    view.addSubview(googleAuthButton)
  }

  private func setupViewsLayout() {
    googleAuthButton.snp.makeConstraints { make in
      make.width.equalTo(200)
      make.height.equalTo(30)
      make.center.equalToSuperview()
    }
  }

  // MARK: - Authentication Methods
  @objc private func makeUserAuthenticationInfo() {
    guard let clientID = FirebaseApp.app()?.options.clientID else { return }

    // Create Google Sign In configuration object.
    let config = GIDConfiguration(clientID: clientID)
    GIDSignIn.sharedInstance.configuration = config

    // Start the sign in flow!
    GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
      guard error == nil else {
        return
      }

      guard let user = result?.user,
        let idToken = user.idToken?.tokenString
      else {
        return
      }

      let credential = GoogleAuthProvider.credential(
        withIDToken: idToken,
        accessToken: user.accessToken.tokenString)

      Auth.auth().signIn(with: credential) { authResult, error in
        if let error = error {
          debugPrint(error.localizedDescription)
        }

        guard let authResult = authResult else { return }
        debugPrint("Log-in successfully...!")
        UserDefaults.standard.set(authResult.user.uid, forKey: "currentUserUID")

        guard
          let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        else { return }
        sceneDelegate.window?.rootViewController = GoogleAuthLoginedViewController()
      }

    }

  }

}

// MARK: - Previews
struct GoogleAuthViewControllerPreview: UIViewControllerRepresentable {
  func makeUIViewController(context: Context) -> GoogleAuthViewController {
    return GoogleAuthViewController()
  }

  func updateUIViewController(_ uiViewController: GoogleAuthViewController, context: Context) {
    // Leave this empty
  }
}

struct GoogleAuthViewController_Previews: PreviewProvider {
  static var previews: some View {
    GoogleAuthViewControllerPreview()
  }
}
