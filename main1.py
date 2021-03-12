import sys
import os.path
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtWidgets import QApplication
import peewee

def on_qml_mouse_clicked(x, y):
    print('mouse clicked:', x, y)

if __name__ == "__main__":
    args = sys.argv
    qml_doc_path = None
    if len(args) > 1:
        qml_doc_path = args[1]
        print('qml doc path:', qml_doc_path)
    else:
        print('no qml doc path :(')
        exit()
    if not os.path.isfile(qml_doc_path):
        print('qml doc is not a file :(')
        exit()
    app = QApplication([])
    engine = QQmlApplicationEngine()
    engine.load(qml_doc_path)
    qml_root = engine.rootObjects()[0]
    qml_root.clicked.connect(on_qml_mouse_clicked)
    sys.exit(app.exec_())
