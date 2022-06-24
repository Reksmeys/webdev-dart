import 'dart:html';
import 'dart:convert';

final DivElement userCard = querySelector('#userCard') as DivElement;
final InputElement fullname = querySelector('#fullname') as InputElement;
final InputElement age = querySelector('#age') as InputElement;
final ButtonElement submit = querySelector('#submit') as ButtonElement;

void main() {
  querySelector("#getUsers")!.onClick.listen(fetchUsers);

  submit.onClick.listen(insertUsers);
}

Future<void> insertUsers(Event e) async {
  e.preventDefault();

  const insertURL = 'http://localhost:9090/users/create';

  try {
    var request = HttpRequest();
    request
      ..open('POST', insertURL)
      ..send(jsonEncode({'name': fullname.value, 'age': age.value}));

    await request.onLoadEnd.first;
    if (request.status == 200) {
      window.alert("បញ្ចូលទិន្នន័យបានជោគជ័យ!");
    }
  } catch (e) {
    print(e);
  }
}

Future<void> fetchUsers(Event _) async {
  const path = 'http://localhost:9090/users';

  try {
    // Make the GET request
    final jsonString = await HttpRequest.getString(path);

    // The request succeeded. Process the JSON.
    final myUsers = await json.decode(jsonString);
    for (final userData in myUsers['data']) {
      userCard.appendHtml("""
          <div class="col-3">
               <div class="card mt-5" style="width: 18rem;">
                <div class="card-body">
                  <h5 class="card-title">${userData['name']}</h5>
                  <p class="card-text">I am from GROUP C, SETEC Institute "Sharing is my happiness"</p>
                  <a href="#" class="btn btn-primary">Age: ${userData['age']}</a>
                </div>
              </div>
          </div>
        """);
    }
  } catch (e) {
    // The GET request failed. Handle the error.
    print("Couldn't open $path");
    userCard.children.add(LIElement()..text = 'Request failed.');
  }
}
