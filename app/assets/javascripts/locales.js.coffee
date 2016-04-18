window.locales =

  #    ######## ##    ##
  #    ##       ###   ##
  #    ##       ####  ##
  #    ######   ## ## ##
  #    ##       ##  ####
  #    ##       ##   ###
  #    ######## ##    ##
  en:
    widgets:
      coordinates:
        error: "Can't retrieve GPS coordinates for the provided address"

    validation:
        blank: "This field cannot be blank"
        invalid_email: 'Please fill a valid email address'

    settings_input:
      required:
        label: 'Mandatory field'

      collection:
        values:
          label: 'Possible values (comma separated list)'
          placeholder: 'item 1, item 2, item 3'

      integer:
        default:
          label: 'Default Value'
          placeholder: '1'

        min:
          label: 'Minimum value'
          placeholder: '0'

        max:
          label: 'Maximum value'
          placeholder: '100'

        step:
          label: 'Step'
          placeholder: '1'

      float:
        default:
          label: 'Default Value'
          placeholder: 1

        min:
          label: 'Minimum value'
          placeholder: '0'

        max:
          label: 'Maximum value'
          placeholder: '100'

        step:
          label: 'Step'
          placeholder: '0.1'

      string:
        limit:
          label: 'Size Limit'
          placeholder: 'no limit'

        textarea:
          label: 'Multiline text'

  #    ######## ########
  #    ##       ##     ##
  #    ##       ##     ##
  #    ######   ########
  #    ##       ##   ##
  #    ##       ##    ##
  #    ##       ##     ##
  fr:
    widgets:
      coordinates:
        error: "Impossible de récupérer les coordonnées GPS de l'adresse indiquée."
      validation:
        blank: 'Ce champ ne peut être vide'
        invalid_email: 'Saisissez une adresse email valide'

    settings_input:
      required:
        label: 'Champ obligatoire'

      collection:
        values:
          label: 'Valeurs possible (liste séparée par des virgules)'
          placeholder: 'item 1, item 2, item 3'

        multiple:
          label: 'Plusieurs choix possible'

      integer:
        default:
          label: 'Valeur par défaut'
          placeholder: '1'

        min:
          label: 'Valeur minimum'
          placeholder: '0'

        max:
          label: 'Valeur maximum'
          placeholder: '100'

        step:
          label: 'Pas'
          placeholder: '1'

      float:
        default:
          label: 'Valeur par défaut'
          placeholder: '1'

        min:
          label: 'Valeur minimum'
          placeholder: '0'

        max:
          label: 'Valeur maximum'
          placeholder: '100'

        step:
          label: 'Pas'
          placeholder: '0.1'

      string:
        limit:
          label: 'Limite de taille'
          placeholder: 'aucune limite'

        textarea:
          label: 'Texte multiligne'
