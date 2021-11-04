export default {
  es: {
    widgets: {
      coordinates: {
        error: "No se puede recuperar las coordenadas GPS de la dirección indicada.",
      },
      validation: {
        blank: 'Este campo no puede estar vacío',
        invalid_email: 'Introduce un email válido',
      },
    },
    settings_input: {
      required: {
        label: 'Campo necesario',
      },
      collection: {
        values: {
          label: 'Posibles valores (lista separada por comas)',
          placeholder: 'item 1, item 2, item 3',
        },
        multiple: {
          label: 'Existen varias opciones',
        },
      },
      integer: {
        default: {
          label: 'Valor predeterminado',
          placeholder: '1',
        },
        min: {
          label: 'Valor mínimo',
          placeholder: '0',
        },
        max: {
          label: 'Valor máximo',
          placeholder: '100',
        },
        step: {
          label: 'Pas',
          placeholder: '1',
        },
      },
      float: {
        default: {
          label: 'Valor predeterminado',
          placeholder: '1',
        },
        min: {
          label: 'Valor mínimo',
          placeholder: '0',
        },
        max: {
          label: 'Valor máximo',
          placeholder: '100',
        },
        step: {
          label: 'Intervalo',
          placeholder: '0.1',
        },
      },
      string: {
        limit: {
          label: 'Límite de tamaño',
          placeholder: 'No existe limitación',
        },
        textarea: {
          label: 'Texto sobre varias líneas',
        }
      }
    },
    stats: {
      sales: "Ventas",
      overall_sales: "Ventas totales (están incluidos los cupones y gastos de envío)",
      split: "Distribución por tipo de joya",
      options_split: "Distribución",
    },
  },
};
