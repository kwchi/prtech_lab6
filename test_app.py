import unittest
from app import Notes

class TestNotes(unittest.TestCase):
     
    def setUp(self):
        self.note = Notes()

    def test_addnote_success(self):
        self.note.addnote("Нова нотатка")
        self.assertEqual(self.note.viewnote(), "Нова нотатка")
    
    def test_addnote_emptystring(self):
        with self.assertRaises(ValueError):
            self.note.addnote("")
    
    def test_removenote_success(self):
        self.note.addnote("Нотатка для видалення")
        removednote = self.note.removenote()
        self.assertEqual(removednote, "Нотатка для видалення")
    
    def test_removenote_fromemptynotebook(self):
        with self.assertRaises(IndexError):
            self.note.removenote()
    
    def test_viewnote_emptynotebook(self):
        with self.assertRaises(IndexError):
            self.note.viewnote()

    def test_searchnote_success(self):
        self.note.addnote("Перша нотатка")
        self.note.addnote("Друга нотатка з текстом")
        found_notes = self.note.searchnote("текстом")
        self.assertEqual(found_notes, ["Друга нотатка з текстом"])

    def test_searchnote_notfound(self):
        self.note.addnote("Перша нотатка")
        with self.assertRaises(ValueError):
            self.note.searchnote("Неіснуючий текст")

    def test_is_empty(self):
        self.assertTrue(self.note.is_empty())
        self.note.addnote("Нова нотатка")
        self.assertFalse(self.note.is_empty())

    @unittest.expectedFailure
    def test_expectedFailure(self):
        self.note.addnote("Нотатка")
        self.note.searchnote("Відсутня нотатка")

if __name__ == "__main__":
    unittest.main()
